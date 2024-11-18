import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ViewBookingsPage extends StatefulWidget {
  const ViewBookingsPage({super.key});

  @override
  State<ViewBookingsPage> createState() => _ViewBookingsPageState();
}

class _ViewBookingsPageState extends State<ViewBookingsPage> {
  List<Map<String, dynamic>> bookings = [];
  bool isLoading = true; // Flag to show loading state

  @override
  void initState() {
    super.initState();
    _fetchBookings();
  }

  // Fetch the bookings from Firebase
  Future<void> _fetchBookings() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetch the bookings subcollection from the current user's document
        final bookingDocs = await FirebaseFirestore.instance
            .collection("users")
            .doc(user.uid)
            .collection("bookings") // Accessing the bookings subcollection
            .get();

        if (bookingDocs.docs.isNotEmpty) {
          setState(() {
            bookings = bookingDocs.docs.map((doc) {
              var data = doc.data() as Map<String, dynamic>;
              // Safely access fields with null-aware operators
              return {
                'stationName': data['stationName'] ??
                    'Unknown Station', // Fallback for null values
                'portId': data['portId'] ?? 'Unknown Port',
                'totalCost': data['totalCost'] ?? 0.0, // Assuming it's a double
                'bookingId': doc.id, // Ensure this is always available
              };
            }).toList();
            isLoading = false; // Stop loading once data is fetched
          });
        } else {
          setState(() {
            isLoading = false;
            bookings = []; // If no bookings exist, set an empty list
          });
        }
      } catch (e) {
        print("Error fetching bookings: $e");
        setState(() {
          isLoading = false; // Stop loading in case of an error
        });
      }
    }
  }

  // Cancel a booking
  Future<void> _cancelBooking(String bookingId) async {
    if (bookingId.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          // Fetch the booking details
          final bookingDoc = await FirebaseFirestore.instance
              .collection('users') // Users collection
              .doc(user.uid) // User's document
              .collection('bookings') // Bookings sub-collection
              .doc(bookingId) // Booking document ID
              .get();

          if (bookingDoc.exists) {
            final bookingData = bookingDoc.data()!;
            final String stationId = bookingData['stationId'];
            final String portId = bookingData['portId'];

            // Delete the booking document
            await FirebaseFirestore.instance
                .collection('users')
                .doc(user.uid)
                .collection('bookings')
                .doc(bookingId)
                .delete();

            // Update the port availability in the station document
            final stationDoc = await FirebaseFirestore.instance
                .collection('stations')
                .doc(stationId)
                .get();

            if (stationDoc.exists) {
              final stationData = stationDoc.data()!;
              List<dynamic> ports = stationData['availablePorts'] ?? [];

              // Find and update the port availability
              for (var port in ports) {
                if (port['portId'] == portId) {
                  port['isAvailable'] = true; // Mark the port as available
                  break;
                }
              }

              // Update the station document in Firestore
              await FirebaseFirestore.instance
                  .collection('stations')
                  .doc(stationId)
                  .update({'availablePorts': ports});
            }

            // Remove the cancelled booking from the local state
            setState(() {
              bookings
                  .removeWhere((booking) => booking['bookingId'] == bookingId);
            });

            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Booking cancelled successfully")));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Booking not found.")));
          }
        } catch (e) {
          print("Error cancelling booking: $e");
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Failed to cancel booking")));
        }
      }
    } else {
      print("Invalid booking ID: $bookingId");
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Booking ID is invalid")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Bookings"),
      ),
      body: isLoading
          ? const Center(
              child:
                  CircularProgressIndicator()) // Show loading while fetching bookings
          : bookings.isEmpty
              ? const Center(child: Text("No bookings available"))
              : ListView.builder(
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    var booking = bookings[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      child: ListTile(
                        title: Text("Station: ${booking['stationName']}"),
                        subtitle: Text("Port: ${booking['portId']} \n"
                            "Cost: \$${booking['totalCost']}"),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            _cancelBooking(booking['bookingId']);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

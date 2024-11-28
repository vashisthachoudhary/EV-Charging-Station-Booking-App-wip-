import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/model/station.dart';
import 'package:ev_app/widgets/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/model/booking.dart'; // Import your Booking model
import 'package:ev_app/model/station.dart'; // Import your Station model

class StationDetailsPagesUser extends StatelessWidget {
  final Station station; // Station object

  const StationDetailsPagesUser({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 44, 98, 45),
        //  backgroundColor: Mytheme.darkGreenish,
        title: Text(station.stationName),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Colors.black],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "Station Details",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              _buildStationCard(),
              const SizedBox(height: 20),
              _buildPricingCard(),
              const SizedBox(height: 20),
              _buildPortsList(),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => _bookStation(station, context),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text("Book Station"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Build card displaying station information
  Widget _buildStationCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF333333),
      child: ListTile(
        leading: const Icon(Icons.ev_station, color: Colors.greenAccent),
        title:
            const Text("Station Name", style: TextStyle(color: Colors.white)),
        subtitle: Text(
          station.stationName,
          style: TextStyle(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  // Build card displaying pricing information
  Widget _buildPricingCard() {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: const Color(0xFF333333),
      child: ListTile(
        leading: const Icon(Icons.attach_money, color: Colors.greenAccent),
        title: const Text("Pricing", style: TextStyle(color: Colors.white)),
        subtitle: Text(
          "Rate: ₹${station.pricingInfo.pricePerHour}/hour\n"
          "Time Spent: ${station.pricingInfo.chargingTimeSpent} hrs\n"
          "Total Cost: ₹${station.pricingInfo.totalCost}",
          style: TextStyle(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  // Build list of available ports
  Widget _buildPortsList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Available Ports",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.green,
            ),
          ),
          const SizedBox(height: 10),
          ...station.availablePorts.map((port) => _buildPortTile(port)),
        ],
      ),
    );
  }

  // Build a tile for each port
  Widget _buildPortTile(Port port) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: const EdgeInsets.only(bottom: 10),
      color: const Color(0xFF444444),
      child: ListTile(
        leading: Icon(
          port.isAvailable ? Icons.check_circle : Icons.cancel,
          color: port.isAvailable ? Colors.greenAccent : Colors.redAccent,
        ),
        title: Text(
          "${port.portType} - ${port.powerOutput}",
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          port.isAvailable ? "Available" : "Occupied",
          style: TextStyle(color: Colors.grey.shade300),
        ),
      ),
    );
  }

  Future<void> _bookStation(Station station, BuildContext context) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      // User is not logged in, show an error or redirect to login page
      print('User not logged in');
      return;
    }

    // Find the first available port
    final availablePort = station.availablePorts.firstWhere(
      (port) => port.isAvailable,
      orElse: () => Port.getEmptyObject(),
    );

    if (availablePort.portId == "") {
      // If no available port is found
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No available ports for booking.')),
      );
      return;
    }

    // Calculate the total cost
    double totalCost = station.pricingInfo.totalCost;

    // Create the booking object
    Booking newBooking = Booking(
      bookingId: '', // Firebase generates this automatically
      stationName: station.stationName,
      stationId: station.stationId, // Include stationId
      portId: availablePort.portId,
      totalCost: totalCost,
    );

    try {
      // Add the booking to the user's bookings collection
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('bookings')
          .add(newBooking.toMap());

      // Fetch the station document
      final stationDoc = await FirebaseFirestore.instance
          .collection('stations')
          .doc(station.stationId)
          .get();

      if (stationDoc.exists) {
        List<dynamic> ports = stationDoc.data()?['availablePorts'] ?? [];

        // Find and update the specific port
        for (var port in ports) {
          if (port['portId'] == availablePort.portId) {
            port['isAvailable'] = false; // Mark the port as unavailable
            break;
          }
        }

        // Update the station document with the modified ports array
        await FirebaseFirestore.instance
            .collection('stations')
            .doc(station.stationId)
            .update({'availablePorts': ports});
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Booking Successful!')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error booking station: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Error booking station. Please try again.')),
      );
    }
  }
}

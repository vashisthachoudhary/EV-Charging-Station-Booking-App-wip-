import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/screens/Authentication/Home/station_detail_user.dart';
import 'package:ev_app/screens/Authentication/Home/stations._detail.dart';
import 'package:flutter/material.dart';
import 'package:ev_app/model/station.dart';
import 'package:ev_app/widgets/theme.dart';

class ListAllStations extends StatefulWidget {
  final String userRole;

  const ListAllStations({Key? key, required this.userRole}) : super(key: key);

  @override
  State<ListAllStations> createState() => ListAllStationsState();
}

class ListAllStationsState extends State<ListAllStations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        // Stream for real-time updates from the "stations" collection
        stream: FirebaseFirestore.instance.collection("stations").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text(
                "Something Went Wrong. Please Try Again.",
                style: TextStyle(color: Colors.red),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text("No Stations Found"),
            );
          }

          // Map each document to a Station object
          List<Station> stations = snapshot.data!.docs.map((doc) {
            return Station.fromMap({
              ...doc.data() as Map<String, dynamic>,
              'stationId': doc.id, // Add the document ID to the station object
            });
          }).toList();

          return ListView.builder(
            itemCount: stations.length,
            itemBuilder: (context, index) {
              Station station = stations[index];

              return GestureDetector(
                onTap: () {
                  widget.userRole == "admin"
                      ? Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                StationDetailsPages(station: station),
                          ),
                        )
                      : Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                StationDetailsPagesUser(station: station),
                          ),
                        );
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: const Color(0xFF1D1D1D), // Dark background color
                  margin: const EdgeInsets.all(12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Display Station Name and Availability
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              station.stationName,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        // Display Station Pricing Info
                        Row(
                          children: [
                            const Icon(Icons.attach_money,
                                color: Colors.greenAccent),
                            const SizedBox(width: 5),
                            Text(
                              "₹${(station.pricingInfo.pricePerHour).toDouble()}/hr",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),

                        // Display Available Ports
                        Row(
                          children: [
                            const Icon(Icons.ev_station,
                                color: Colors.greenAccent),
                            const SizedBox(width: 5),
                            Text(
                              "${station.availablePorts.length} ports available",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),

                        // Register or View Details Button
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              widget.userRole == "admin"
                                  ? Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StationDetailsPages(
                                                station: station),
                                      ),
                                    )
                                  : Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            StationDetailsPagesUser(
                                                station: station),
                                      ),
                                    );
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.grey.shade800,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: const Text("View Details"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

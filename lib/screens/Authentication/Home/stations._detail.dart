import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/model/station.dart';
import 'package:ev_app/widgets/theme.dart';
import 'package:flutter/material.dart';


class StationDetailsPages extends StatelessWidget {
  final Station station; // Station object

  const StationDetailsPages({super.key, required this.station});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
              const Padding (
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
                  onPressed: () => _deleteStation(station),
                  icon: const Icon(Icons.delete, color: Colors.white),
                  label: const Text("Delete Station"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
        title: const Text("Station Name", style: TextStyle(color: Colors.white)),
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

  // Function to delete station from Firestore
  Future<void> _deleteStation(Station station) async {
    try {
      await FirebaseFirestore.instance
          .collection("stations")
          .doc(station.stationName) // Assuming stationName is unique
          .delete();
      print("Station Deleted Successfully");
    } catch (e) {
      print("Error deleting station: $e");
    }
  }
}

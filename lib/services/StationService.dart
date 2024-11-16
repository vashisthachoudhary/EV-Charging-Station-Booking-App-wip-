import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/model/station.dart';


class StationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  StationService();

  // Add a station to Firestore
  Future<String> addStation(Station station, String userUid) async {
    try {
      DocumentReference docRef = await _db
          .collection('users')
          .doc(userUid)
          .collection('stations')
          .add(station.toMap());
      String stationId = docRef.id;

      // Save the station ID (docRef.id) in the Firestore document
      await docRef.update({'stationId': stationId});

      print('[StationService] Station Created with ID: $stationId');
      return "Station Added Successfully with ID: $stationId";
    } catch (e) {
      print('[StationService] Error adding station: $e');
      return "Error adding station";
    }
  }

  // Fetch stations for a specific user
  Stream<List<Station>> fetchStations(String userUid) {
    return _db
        .collection('users')
        .doc(userUid)
        .collection('stations')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data();
              print("Fetched Station Data: $data"); // Debugging statement
              return Station.fromMap(data);
            }).toList());
  }

  // Fetch all stations for all users (for discovery, etc.)
  Stream<List<Station>> fetchAllStations() {
    return _db
        .collection('stations')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              Map<String, dynamic> data = doc.data();
              print("Fetched Station Data for Discover: $data"); // Debugging statement
              return Station.fromMap(data);
            }).toList());
  }

  // Update a station in Firestore
  Future<void> updateStation(Station station, String userUid, String docId) async {
    try {
      await _db
          .collection('users')
          .doc(userUid)
          .collection('stations')
          .doc(docId)
          .update(station.toMap());
      print('[StationService] Station Updated with ID: $docId');
    } catch (e) {
      print('[StationService] Error updating station: $e');
    }
  }

  // Delete a station from Firestore
  Future<void> deleteStation(String userUid, String docId) async {
    try {
      await _db
          .collection('users')
          .doc(userUid)
          .collection('stations')
          .doc(docId)
          .delete();
      print('[StationService] Station Deleted with ID: $docId');
    } catch (e) {
      print('[StationService] Error deleting station: $e');
    }
  }
}

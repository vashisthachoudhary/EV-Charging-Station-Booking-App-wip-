class Booking {
  String bookingId;
  String stationName;
  String stationId; // New field for the station ID
  String portId;
  double totalCost;

  Booking({
    required this.bookingId,
    required this.stationName,
    required this.stationId, // Initialize stationId
    required this.portId,
    required this.totalCost,
  });

  // Convert a Booking instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'stationName': stationName,
      'stationId': stationId, // Include stationId in the map
      'portId': portId,
      'totalCost': totalCost,
    };
  }

  // Create a Booking instance from a Map
  factory Booking.fromMap(Map<String, dynamic> map) {
    return Booking(
      bookingId: map['bookingId'],
      stationName: map['stationName'],
      stationId: map['stationId'], // Retrieve stationId from the map
      portId: map['portId'],
      totalCost: map['totalCost'],
    );
  }
}

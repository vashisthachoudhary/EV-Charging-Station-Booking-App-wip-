class Port {
  String portId;          // Unique identifier for the port
  String powerOutput;     // e.g., '25W', '50W', etc.
  String portType;        // e.g., 'Normal', 'Rapid'
  bool isAvailable;       // Is the port available or occupied

  Port({
    required this.portId,
    required this.powerOutput,
    required this.portType,
    required this.isAvailable,
  });

  // Convert a Port instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'portId': portId,
      'powerOutput': powerOutput,
      'portType': portType,
      'isAvailable': isAvailable,
    };
  }

  // Create a Port instance from a Map
  factory Port.fromMap(Map<String, dynamic> map) {
    return Port(
      portId: map['portId'] ?? "",
      powerOutput: map['powerOutput'] ?? "",
      portType: map['portType'] ?? "",
      isAvailable: map['isAvailable'] ?? false,
    );
  }

  // Get an empty Port object
  static Port getEmptyObject() {
    return Port(
      portId: "",
      powerOutput: "",
      portType: "",
      isAvailable: false,
    );
  }
}

class Pricing {
  double pricePerHour;      // Cost per hour for charging
  int chargingTimeSpent;    // Time spent charging in hours

  Pricing({
    required this.pricePerHour,
    required this.chargingTimeSpent,
  });

  // Calculate the total cost
  double get totalCost => pricePerHour * chargingTimeSpent;

  // Convert a Pricing instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'pricePerHour': pricePerHour,
      'chargingTimeSpent': chargingTimeSpent,
      'totalCost': totalCost,
    };
  }

  // Create a Pricing instance from a Map
  factory Pricing.fromMap(Map<String, dynamic> map) {
    return Pricing(
      pricePerHour: map['pricePerHour'].toDouble() ?? 0.0,
      chargingTimeSpent: map['chargingTimeSpent'] ?? 0,
    );
  }

  // Get an empty Pricing object
  static Pricing getEmptyObject() {
    return Pricing(
      pricePerHour: 0.0,
      chargingTimeSpent: 0,
    );
  }
}

class Station {
  String stationName;              // Name of the station
  List<Port> availablePorts;       // List of available ports
  Pricing pricingInfo;             // Pricing information

  Station({
    required this.stationName,
    required this.availablePorts,
    required this.pricingInfo,
  });

  // Convert a Station instance to a Map
  Map<String, dynamic> toMap() {
    return {
      'stationName': stationName,
      'availablePorts': availablePorts.map((port) => port.toMap()).toList(),
      'pricingInfo': pricingInfo.toMap(),
    };
  }

  // Create a Station instance from a Map
  factory Station.fromMap(Map<String, dynamic> map) {
    return Station(
      stationName: map['stationName'] ?? "",
      availablePorts: List<Port>.from(
          map['availablePorts']?.map((portMap) => Port.fromMap(portMap)) ??
          []),
      pricingInfo: Pricing.fromMap(map['pricingInfo'] ?? {}),
    );
  }

  // Get an empty Station object
  static Station getEmptyObject() {
    return Station(
      stationName: "",
      availablePorts: [],
      pricingInfo: Pricing.getEmptyObject(),
    );
  }
}

void main() {
  // Example of creating a Station object
  List<Port> ports = [
    Port(portId: 'P1', powerOutput: '25W', portType: 'Normal', isAvailable: true),
    Port(portId: 'P2', powerOutput: '50W', portType: 'Rapid', isAvailable: false),
  ];

  Pricing pricing = Pricing(pricePerHour: 10.0, chargingTimeSpent: 2);

  Station station = Station(
    stationName: 'EV Station 1',
    availablePorts: ports,
    pricingInfo: pricing,
  );

  // Convert Station object to Map
  Map<String, dynamic> stationMap = station.toMap();
  print('Station as Map: $stationMap');

  // Create Station object from Map
  Station newStation = Station.fromMap(stationMap);
  print('New Station name: ${newStation.stationName}');
}

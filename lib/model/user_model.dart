import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/utils/util.dart';
import 'package:ev_app/model/booking.dart';
class AppUser {
  String name;
  String phone;
  String email;
  String role;
  List<Booking> bookings;

  // Constructor
  AppUser({
    required this.name,
    required this.phone,
    required this.email,
    required this.role,
    required this.bookings,
  });

  // Static method to get an empty object
  static AppUser getAppUserEmptyObject() {
    return AppUser(
      name: "",
      phone: "",
      email: "",
      role: "",
      bookings: [],
    );
  }

  // Method to convert object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'role': role,
      'bookings': bookings.map((booking) => booking.toMap()).toList(),
    };
  }

  // Factory constructor to create an object from a map
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'] ?? "",
      phone: map['phone'] ?? "",
      email: map['email'] ?? "",
      role: map['role'] ?? "",
      bookings: List<Booking>.from(
        map['bookings']?.map((bookingMap) => Booking.fromMap(bookingMap)) ?? [],
      ),
    );
  }
}

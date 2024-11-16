import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ev_app/utils/util.dart';

class AppUser {
  String name;
  String phone;
  String email;

  // Constructor
  AppUser({
    required this.name,
    required this.phone,
    required this.email,
  });

  // Static method to get an empty object
  static AppUser getAppUserEmptyObject() {
    return AppUser(
      name: "",
      phone: "",
      email: "",
    );
  }

  // Method to convert object to a map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
    };
  }

  // Factory constructor to create an object from a map
  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      name: map['name'] ?? "",
      phone: map['phone'] ?? "",
      email: map['email'] ?? "",
    );
  }
}

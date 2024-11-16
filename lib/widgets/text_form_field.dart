import 'package:flutter/material.dart';

class MyTextFormField extends StatelessWidget {
  final dynamic initVal;
  final dynamic onSav;
  final dynamic hint;
  final Icon icon;

  const MyTextFormField(
      {super.key,
      this.initVal,
      required this.onSav,
      required this.hint,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        initialValue: initVal,
        style: const TextStyle(color: Color(0xFF0D47A1)), // Dark blue text

        decoration: InputDecoration(
          prefixIcon: icon,
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFF1976D2)), // Lighter blue for hint
          
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(width: 2, color: Colors.red),
          ),
          
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(width: 2, color: Color(0xFF0D47A1)), // Darker blue when focused
          ),
          
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            borderSide: BorderSide(width: 2, color: Color(0xFF1976D2)), // Light blue when enabled
          ),
          
          border: const OutlineInputBorder(
            borderSide: BorderSide(width: 2, color: Color(0xFF1976D2)), // Default blue border
            borderRadius: BorderRadius.all(Radius.circular(16)),
          ),
        ),
        
        onSaved: onSav);
  }
}

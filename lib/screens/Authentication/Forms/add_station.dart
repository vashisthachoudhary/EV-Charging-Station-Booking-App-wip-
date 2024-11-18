import 'package:ev_app/model/station.dart';
import 'package:ev_app/widgets/text_form_field.dart';
import 'package:ev_app/widgets/theme.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:velocity_x/velocity_x.dart';

class AddStation extends StatefulWidget {
  const AddStation({super.key});

  @override
  State<AddStation> createState() => _AddStationState();
}

class _AddStationState extends State<AddStation> {
  // Create an empty station object to populate with form data.
  Station station = Station.getEmptyObject();

  // Global key to track the form's state.
  final formKey = GlobalKey<FormState>();

  // Boolean to indicate whether a save operation is in progress.
  bool saveChange = false;

  // Function to add station details to Firestore.
  Future<void> addStationToDB() async {
    setState(() {
      saveChange = true; // Start showing progress indicator.
    });

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save(); // Save the form's current state.

      try {
        print("Saving Station Started");
        print("Station Data: ${station.toMap()}");

        // Reference to the 'stations' collection in Firestore.
        final docRef = FirebaseFirestore.instance.collection('stations').doc();

        // Store the station data in Firestore.
        await docRef.set(station.toMap());
        print("Saving Station Completed");

        // Show a success message.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: "Station Added Successfully".text.make()),
        );
      } catch (e) {
        print("Error adding station: $e");

        // Show an error message in case of failure.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: "Failed to add station: $e".text.make()),
        );
      } finally {
        setState(() {
          saveChange = false; // Stop showing progress indicator.
        });
      }
    } else {
      setState(() {
        saveChange = false; // Form validation failed, stop indicator.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.black,
        backgroundColor: Colors.blue,
        title: "Add Station".text.make(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: formKey, // Attach the form key.
              child: Column(
                children: [
                  // Header for the form.
                  "Add Station Data"
                      .text
                      .xl3
                      .bold
                      .color(Mytheme.darkForeground)
                      .makeCentered(),
                  20.heightBox,

                  // Station Name Field.
                  MyTextFormField(
                    onSav: (value) {
                      station.stationName = value!;
                    },
                    hint: "Station Name",
                    icon: const Icon(Icons.ev_station),
                  ),
                  20.heightBox,

                  // Available Ports Field (Comma Separated Input).
                  MyTextFormField(
                    onSav: (value) {
                      if (value != null && value.isNotEmpty) {
                        try {
                          // Convert comma-separated input into a list of ports.
                          station.availablePorts =
                              value.split(',').map<Port>((port) {
                            return Port(
                              portId: port.trim(),
                              powerOutput: "25W", // Customize as needed.
                              portType: "Normal",
                              isAvailable: true,
                            );
                          }).toList();
                        } catch (e) {
                          print("Error parsing ports: $e");

                          // Show error if the port input is invalid.
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                content: "Invalid port format.".text.make()),
                          );
                        }
                      } else {
                        station.availablePorts = []; // Assign empty list if no input.
                      }
                    },
                    hint: "Available Ports (comma separated)",
                    icon: const Icon(Icons.power_outlined),
                  ),
                  20.heightBox,

                  // Pricing Field (Price per Hour).
                  MyTextFormField(
                    onSav: (value) {
                      station.pricingInfo.pricePerHour =
                          double.parse(value!); // Convert string to double.
                    },
                    hint: "Price per Hour",
                    icon: const Icon(Icons.attach_money),
                    //keyboardType: TextInputType.number, // Numeric input.
                  ),
                  20.heightBox,
                  
                  // Charging Time Spent Field.
                  MyTextFormField(
                    onSav: (value) {
                      station.pricingInfo.chargingTimeSpent =
                          int.parse(value!); // Convert string to int.
                    },
                    hint: "Charging Time Spent (in hours)",
                    icon: const Icon(Icons.timer_outlined),
                    //keyboardType: TextInputType.number, // Numeric input.
                  ),
                  20.heightBox,

                  // Submit Button to add the station.
                    SizedBox(
                    width: 200,
                     child: ElevatedButton(
                      onPressed: addStationToDB,
                       style:const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.black),
                       ),
                     child: saveChange
                           ? const CircularProgressIndicator(
                             strokeWidth: 1, color: Colors.green)
                         : "Add Station".text.white.xl.make(),
                ),)
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

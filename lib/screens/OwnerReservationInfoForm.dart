import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/tableinfo.dart';
import '../widgets/customBtn.dart';
import '../providers/restaurantProvider.dart';
import '../widgets/systembars.dart';
import '../providers/userProvider.dart';

class OwnerReservationInfoForm extends StatefulWidget {
  @override
  _OwnerReservationInfoFormState createState() =>
      _OwnerReservationInfoFormState();
}

class _OwnerReservationInfoFormState extends State<OwnerReservationInfoForm> {
  final _formKey = GlobalKey<FormState>();
  List<TableInfo> tables = [
    TableInfo(tableNumber: 1, seatCount: 4),
  ];
  String? restaurantId; // Store the restaurant ID once fetched

  Future<void> saveTableInfo(String restaurantId) async {
    try {
      final batch = FirebaseFirestore.instance.batch();
      final tablesCollection = FirebaseFirestore.instance
          .collection('restaurants')
          .doc(restaurantId)
          .collection('tables');

      for (var table in tables) {
        batch.set(
          tablesCollection.doc(table.id),
          {
            'tableNumber': table.tableNumber,
            'seatCount': table.seatCount,
          },
        );
      }
      await batch.commit();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Reservation information saved successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save table information: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final restaurantProvider = Provider.of<RestaurantProvider>(context);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    final ownerId = userProvider.id; // Get the logged-in owner's ID

    // Fetch restaurantId only if it's not already available
    if (restaurantId == null && ownerId != null) {
      restaurantProvider.fetchRestaurantIdByOwnerId(ownerId).then((id) {
        setState(() {
          restaurantId = id; // Set the fetched restaurantId
        });
      });
    }

    // If the restaurantId is still null, show a loading spinner
    if (restaurantId == null) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: SingleChildScrollView( // Wrap the entire body in SingleChildScrollView
        child: Padding(
          padding: const EdgeInsets.all(18.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Add Reservation Information",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                // Table info section
                _buildTableInfoSection(),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    CustomButton(
                      text: "Add Table",
                      onPressed: _addTable,
                    ),
                    CustomButton(
                      text: "Submit Form",
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          if (restaurantId != null) {
                            await saveTableInfo(restaurantId!);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Invalid Restaurant ID'),
                              ),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _addTable() {
    setState(() {
      tables.add(
        TableInfo(tableNumber: 0, seatCount: 0), // Default values
      );
    });
  }

  Widget _buildTableInfoSection() {
    if (tables.isEmpty) {
      return Center(child: Text("No tables added"));
    }

    return ListView.builder(
      shrinkWrap: true, // Ensures it takes only the required space
      itemCount: tables.length,
      itemBuilder: (context, index) {
        final table = tables[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Card(
            elevation: 2, // Drop shadow effect
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Table Number Input
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 40,
                          child: TextFormField(
                            initialValue: table.tableNumber == 0
                                ? ''
                                : table.tableNumber.toString(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Table Number",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter table number';
                              }
                              if (tables.any((t) =>
                                  t.tableNumber == int.tryParse(value) &&
                                  t != table)) {
                                return 'Duplicate table number';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                table.tableNumber = int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16), // Space between inputs
                  // Seat Count Input
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5),
                        SizedBox(
                          height: 40,
                          child: TextFormField(
                            initialValue: table.seatCount == 0
                                ? ''
                                : table.seatCount.toString(),
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Seats Count",
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter seat count';
                              }
                              return null;
                            },
                            onChanged: (value) {
                              setState(() {
                                table.seatCount = int.tryParse(value) ?? 0;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _removeTable(index),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _removeTable(int index) {
    setState(() {
      tables.removeAt(index);
    });
  }
}

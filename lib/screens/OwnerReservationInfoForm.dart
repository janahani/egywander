import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:egywander/providers/userProvider.dart';
import 'loginScreen.dart';
import 'accountsettingsScreen.dart';
import 'aboutusScreen.dart';
import '../widgets/systembars.dart';
import 'package:egywander/widgets/accountmenubtns.dart';
import 'OwnerReservationInfoForm.dart';
import 'viewReservationScreen.dart';
import '../models/tableinfo.dart';
import '../widgets/customBtn.dart';

class OwnerReservationInfoForm extends StatefulWidget {
  @override
  _OwnerReservationInfoFormState createState() =>
      _OwnerReservationInfoFormState();
}

class _OwnerReservationInfoFormState extends State<OwnerReservationInfoForm> {
  final _formKey = GlobalKey<FormState>();
  List<TableInfo> tables = [
    TableInfo(tableNumber: 1, seatCount: 4), // Initialize with a default table
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: appBar(context),
      bottomNavigationBar: bottomNavigationBar(context),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Your Restaurant's Reservation Information",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: SingleChildScrollView(
                  child: _buildTableInfoSection(),
                ),
              ),
              
              const SizedBox(height: 10),
              Center(
                    child: Container(
                      width: 180, // Adjust the width as needed
                      child: CustomButton(
                        text: "Add Table",
                        onPressed: _addTable,

                      ),
                    ),
                  ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  width: 180, // Adjust the width as needed
                  child: CustomButton(
                    text: "Submit Form",
                    onPressed: () {
                      if (_formKey.currentState?.validate() ?? false) {
                        // Form submission logic here
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                                  'Reservation information submitted successfully')),
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addTable() {
    setState(() {
      tables.add(
        TableInfo(tableNumber: tables.length + 1, seatCount: 4),
      );
    });
  }

  Widget _buildTableInfoSection() {
    return Column(
      children: tables
          .map((table) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Card(
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Table ${table.tableNumber}",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "Seats: ",
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black54),
                            ),
                            Container(
                              width: 40,
                              child: TextFormField(
                                initialValue: table.seatCount.toString(),
                                decoration: InputDecoration(
                                  hintText: '4',
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 8),
                                ),
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter seat count';
                                  }
                                  return null;
                                },
                                onChanged: (value) {
                                  setState(() {
                                    table.seatCount =
                                        int.tryParse(value) ?? table.seatCount;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ))
          .toList(),
    );
  }
}

import 'package:flutter/material.dart';

class OwnerReservationInfoForm extends StatefulWidget {
  @override
  _OwnerReservationInfoFormState createState() => _OwnerReservationInfoFormState();
}

class _OwnerReservationInfoFormState extends State<OwnerReservationInfoForm> {
  final _formKey = GlobalKey<FormState>();
  List<TableInfo> tables = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Submit Reservation Info"),
        backgroundColor: Colors.deepOrange,
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Add Your Restaurant's Reservation Information",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              _buildTableInfoSection(),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    // Form submission logic here
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Reservation information submitted successfully')),
                    );
                  }
                },
                child: Text("Submit"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  textStyle: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTableInfoSection() {
    return Column(
      children: [
        for (int i = 0; i < 3; i++) // You can dynamically add more tables as needed
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Table ${i + 1}",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        Text(
                          "Seats: ",
                          style: TextStyle(fontSize: 14, color: Colors.black54),
                        ),
                        Container(
                          width: 40,
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: '4',
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(horizontal: 8),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter seat count';
                              }
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class TableInfo {
  final int tableNumber;
  final int seatCount;

  TableInfo({required this.tableNumber, required this.seatCount});
}

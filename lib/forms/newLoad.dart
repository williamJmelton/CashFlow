import 'package:flutter/material.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

// Define a custom Form widget.
class MyCustomForm extends StatefulWidget {
  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'CashApp';
  final customerController = TextEditingController();
  final amountController = TextEditingController();
  CollectionReference transactions =
      FirebaseFirestore.instance.collection('transactions');

  Future<void> addUser() {
    // Call the user's CollectionReference to add a new user
    return transactions
        .add({
          'customerName': customerController.text, // John Doe
          'amount': amountController.value,
          'method': dropdownValue
        })
        .then((value) => print("Transaction Added"))
        .catchError((error) => print("Failed to log transaction: $error"));
  }

  @override
  Widget build(BuildContext context) {
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: const InputDecoration(
                icon: Icon(Icons.person),
                hintText: 'Who are you loading?',
                labelText: 'Customer',
              ),
              controller: customerController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter a customer name';
                }
                return null;
              },
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                icon: Icon(Icons.money),
                hintText: 'Amount Loaded',
                labelText: 'Amount',
              ),
              controller: amountController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter an amount for the customer';
                }
                return null;
              },
            ),
            Container(
              alignment: Alignment.centerRight,
              child: Row(
                // widthFactor: 0.9,
                children: [
                  Icon(Icons.credit_card_rounded, color: Colors.grey),
                  Padding(
                    padding: const EdgeInsets.all(11),
                    child: DropdownButton<String>(
                      value: dropdownValue,
                      // icon: const Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: const TextStyle(color: Colors.green),
                      underline: Container(
                        height: 2,
                        color: Colors.green,
                      ),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownValue = newValue!;
                        });
                      },
                      items: <String>['CashApp', 'Venmo', 'Apple Pay', 'Paypal']
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Validate returns true if the form is valid, or false otherwise.
                if (_formKey.currentState!.validate()) {
                  // If the form is valid, display a snackbar. In the real world,
                  // you'd often call a server or save the information in a database.
                  addUser();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Sending...')));
                }
              },
              child: Text('Log Transaction'),
            ),
          ],
        ),
      ),
    );
  }
}

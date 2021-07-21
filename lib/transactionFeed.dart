import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TransFeed extends StatefulWidget {
  @override
  _TransFeedState createState() => _TransFeedState();
}

class _TransFeedState extends State<TransFeed> {
  final Stream<QuerySnapshot> _transactionStream =
      FirebaseFirestore.instance.collection('transactions').snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _transactionStream,
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.hasError) {
          return Container(
              child: Text('Something went wrong',
                  textDirection: TextDirection.ltr));
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
              child: Text("Loading", textDirection: TextDirection.ltr));
        }

        return Container(
          child: SizedBox(
            width: 400,
            height: 300,
            child: new ListView(
              children: snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> data = document.data();
                return ListTile(
                  title: Text(data['customerName']),
                  subtitle: Text(data['method']),
                  leading: Text("\$" + data['amount'].toString()),
                  // trailing: Text(data['time'])
                  // trailing: Text(Timestamp.fromDate(data['date']).toString()),
                  // trailing: Text(data['method']),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

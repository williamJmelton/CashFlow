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
          return Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text("Loading");
        }

        return new ListView(
          children: snapshot.data!.docs.map((DocumentSnapshot document) {
            Map<String, dynamic> data = document.data();
            return new Text(data['customerName']);
          }).toList(),
        );
      },
    );
  }
}

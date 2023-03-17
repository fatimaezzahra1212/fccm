import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

final _firestore = FirebaseFirestore.instance;

class NnotificationScreen extends StatefulWidget {
  static const routeName = '/notification-screen';

  @override
  _NnotificationScreenState createState() => _NnotificationScreenState();
}

class _NnotificationScreenState extends State<NnotificationScreen> {
  final _auth = FirebaseAuth.instance;
  late User _currentUser;
  final _numOfPeopleController = TextEditingController();
  final _destinationController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _currentUser = _auth.currentUser!;
  }

  sendNotification(String title, String token) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };
    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'AAAAlW26QbI:APA91bGy8FgSJQhi2WFwbweDLWfBn0yrajWAj8CCo5Oyjmly2LlqbT9rhUvQt7cywcp2jIjRUFj172t6XXe1hFqodUauMa_I1wm5ULP6K85cZUrfiFhhGvVzE6chkqFPozPTNXcymk_a'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body': 'You are followed by someone'
                },
                'priority': 'high',
                'data': data,
                'to': '$token'
              }));

      if (response.statusCode == 200) {
        print("Yeh notificatin is sended");
      } else {
        print("Error");
      }
    } catch (e) {}
  }

  sendNotificationToTopic(String title) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'message': title,
    };

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'AAAAlW26QbI:APA91bGy8FgSJQhi2WFwbweDLWfBn0yrajWAj8CCo5Oyjmly2LlqbT9rhUvQt7cywcp2jIjRUFj172t6XXe1hFqodUauMa_I1wm5ULP6K85cZUrfiFhhGvVzE6chkqFPozPTNXcymk_a'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body': 'You are followed by someone'
                },
                'priority': 'high',
                'data': data,
                'to': '/topics/subscription'
              }));
      if (response.statusCode == 200) {
        print("Notification sent to topic");
      } else {
        print("Error sending notification");
      }
    } catch (e) {
      print("Error sending notification: $e");
    }
  }

  void _sendNotification() async {
    final title = "New trip request!";
    final numOfPeople = _numOfPeopleController.text.trim();
    final destination = _destinationController.text.trim();
    if (numOfPeople.isEmpty || destination.isEmpty) {
      return;
    }

    final tokensSnapshot = await _firestore
        .collection('user_driver')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();

    final tokens = tokensSnapshot.get('token');

    if (tokens is String) {
      sendNotification(title, tokens);
    } else if (tokens is Iterable) {
      for (final token in tokens) {
        sendNotification(title, token);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Notifications"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _numOfPeopleController,
              decoration: InputDecoration(labelText: "Number of people"),
            ),
            SizedBox(height: 16.0),
            TextFormField(
              controller: _destinationController,
              decoration: InputDecoration(labelText: "Destination"),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _sendNotification,
              child: Text("Send notification"),
            ),
          ],
        ),
      ),
    );
  }
}

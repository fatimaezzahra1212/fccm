import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Driver {
  final String id;
  final String name;

  Driver({
    required this.id,
    required this.name,
  });
}

Future<List<Driver>> _getDrivers() async {
  final drivers = <Driver>[];
  final snapshot =
      await FirebaseFirestore.instance.collection('user_driver').get();

  for (final doc in snapshot.docs) {
    final driver = Driver(
      id: doc.id,
      name: doc.get('name'),
    );
    drivers.add(driver);
  }

  return drivers;
}

class NotificationSender extends StatefulWidget {
  const NotificationSender({Key? key}) : super(key: key);

  @override
  _NotificationSenderState createState() => _NotificationSenderState();
}

class _NotificationSenderState extends State<NotificationSender> {
  final _messageController = TextEditingController();
  late final FirebaseFirestore _firestore;
  String? _selectedDriverId;

  @override
  void initState() {
    super.initState();
    _firestore = FirebaseFirestore.instance;
  }

  Future<void> _sendNotification() async {
    if (_selectedDriverId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Please select a driver to send a notification to.')));
      return;
    }

    // Get the device token of the selected driver
    final driverSnapshot =
        await _firestore.collection('user_driver').doc(_selectedDriverId).get();

    if (!driverSnapshot.exists) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('The selected driver does not exist.')));
      return;
    }

    final deviceToken = driverSnapshot.get('token');

    // Send the notification
    final url = Uri.parse('https://fcm.googleapis.com/fcm/send');
    final headers = {
      'Content-Type': 'application/json',
      'Authorization':
          'AAAAlW26QbI:APA91bGy8FgSJQhi2WFwbweDLWfBn0yrajWAj8CCo5Oyjmly2LlqbT9rhUvQt7cywcp2jIjRUFj172t6XXe1hFqodUauMa_I1wm5ULP6K85cZUrfiFhhGvVzE6chkqFPozPTNXcymk_a'
    };
    final body = jsonEncode({
      'to': deviceToken,
      'notification': {
        'title': 'New message',
        'body': _messageController.text,
      }
    });
    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Notification sent successfully')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to send notification')));
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Driver>>(
      future: _getDrivers(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          return Builder(
            builder: (context) => Scaffold(
              appBar: AppBar(
                title: const Text("Send Notification"),
              ),
              body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Driver',
                        border: OutlineInputBorder(),
                      ),
                      value: _selectedDriverId,
                      onChanged: (value) {
                        setState(() {
                          _selectedDriverId = value;
                        });
                      },
                      items: [
                        for (final driver in snapshot.data!)
                          DropdownMenuItem<String>(
                            value: driver.id,
                            child: Text(driver.name),
                          )
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        labelText: 'Message',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _sendNotification,
                      child: const Text('Send Notification'),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else {
          return Container(); // Add a default return statement
        }
      },
    );
  }
}

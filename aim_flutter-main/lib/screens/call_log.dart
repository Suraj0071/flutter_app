import 'dart:io';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:call_log/call_log.dart';

class call_log extends StatefulWidget {
  const call_log({Key? key}) : super(key: key);

  @override
  State<call_log> createState() => _call_log();
}

class _call_log extends State<call_log> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Log App'),
      ),
      body: Center(
        child: Builder(
          builder: (BuildContext context) {
            return Visibility(
              visible: Platform.isAndroid,
              replacement: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      color: Colors.red[500],
                    ),
                    const SizedBox(
                      width: 6,
                    ),
                    const Text("Available for android users only")
                  ]),
              child: ElevatedButton(
                child: Text('Request Permissions'),
                onPressed: () async {
                  var status = await Permission.contacts.request();
                  print(status);
                  if (status.isGranted) {
                    Iterable<CallLogEntry> entries = await CallLog.get();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CallLogScreen(entries),
                      ),
                    );
                  } else {
                    print('NOT GIVEN PERMISSION');
                    // Permission not granted, handle it accordingly
                  }
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

class CallLogScreen extends StatelessWidget {
  final Iterable<CallLogEntry> entries;

  CallLogScreen(this.entries);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Call Log Entries'),
      ),
      body: ListView.builder(
        itemCount: entries.length,
        itemBuilder: (context, index) {
          var entry = entries.elementAt(index);
          return ListTile(
            title: Text('Number: ${entry.number}'),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Type: ${entry.callType}'),
                // Text('Date: ${entry.dateTime}'),
                Text('Duration: ${entry.duration}'),
              ],
            ),
          );
        },
      ),
    );
  }
}

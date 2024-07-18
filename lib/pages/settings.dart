// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:news_app/api/navigation_api.dart';
import 'package:news_app/api/storage_api.dart';
import 'package:news_app/pages/login.dart';
import 'package:news_app/style/text_style.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SizedBox.expand(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 15),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: const Color.fromARGB(255, 91, 175, 186),
                child: Text(StorageApi.getUsername().substring(0, 2)),
              ),
            ),
            Text(
              StorageApi.getUsername(),
              style: sectionHeaderStyle,
            ),
            const Divider(
              height: 2,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

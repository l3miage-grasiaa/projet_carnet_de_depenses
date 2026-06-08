import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/storage.dart';

class ProfilePage extends StatelessWidget {
  final User user;

  const ProfilePage({
    super.key,
    required this.user
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        return Navigator.of(context).pop(user);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Profil"),
        ),
        body: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(user.picture),
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text("${user.firstName} ${user.lastName}"),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red[100]),
              onPressed: () {
                StorageService().clearUser(); // 1. Hapus user dari storage lokal HP (Halaman 8)
                Navigator.of(context).pop();  // 2. Pulang kembali ke halaman utama
              },
              child: const Text("Déconnexion (Logout)", style: TextStyle(color: Colors.red)),
            )
          ],
        ),
      )
    )    ;
  }
}

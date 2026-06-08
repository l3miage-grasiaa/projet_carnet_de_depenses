import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // Import package http dengan alias 'http'
import '../models/user.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            try {
              // 1. Mengambil data user dari API internet (Halaman 7 Modul)
              final response = await http.get(
                Uri.parse('https://jsonplaceholder.typicode.com/users/1'),
              );

              if (response.statusCode == 200) {
                // 2. Mengubah teks response body JSON menjadi Map
                final Map<String, dynamic> apiData = jsonDecode(response.body);

                // 3. Modul meminta kita membuat objek User dari data ini (Halaman 7)
                // Karena API jsonplaceholder tidak punya field 'picture', kita modifikasi sedikit
                User loggedInUser = User(
                  apiData['name'].toString().split(' ')[0], // Mengambil kata pertama sebagai firstName
                  apiData['username'],                      // lastName diisi username dari API
                  "assets/shinchan_profil_image.jpeg",      // Gambar lokal sebagai default
                );

                // 4. Pulang ke HomePage sambil membawa data objek User yang berhasil login
                Navigator.of(context).pop(loggedInUser);
              } else {
                print("Gagal mengambil data dari API: ${response.statusCode}");
              }
            } catch (e) {
              print("Terjadi error koneksi: $e");
            }
          },
          child: const Text("Login"),
        ),
      ),
    );
  }
}
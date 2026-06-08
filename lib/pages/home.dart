import 'package:flutter/material.dart';
import 'profile.dart';
import 'login.dart'; // Import LoginPage yang baru dibuat
import '../models/user.dart';
import '../services/storage.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    final storage = StorageService();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("TP2 & Storage"),
        actions: [
          IconButton(
            onPressed: () async {
              // 1. Cek apakah ada user yang sudah tersimpan di memori HP (Halaman 8)
              User? savedUser = storage.getUser();

              if (savedUser != null) {
                // KONDISI A: User sudah ada -> Langsung ke Halaman Profil
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(user: savedUser),
                ));
              } else {
                // KONDISI B: Belum ada user -> Harus Login dulu ke internet
                // Menunggu hasil kembalian dari LoginPage lewat Navigator.pop
                var result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));

                // Jika user sukses login dan membawa objek User kembali (Halaman 8)
                if (result != null && result is User) {
                  storage.saveUser(result); // Simpan permanen ke storage lokal HP

                  // Setelah sukses simpan, langsung antarkan ke halaman Profil
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ProfilePage(user: result),
                  ));
                }
              }
            },
            icon: const Icon(Icons.account_circle, size: 40),
          )
        ],
      ),
      body: const Center(
        child: Text("Konten Utama Aplikasi"),
      ),
    );
  }
}
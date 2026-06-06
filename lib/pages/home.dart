import 'package:flutter/material.dart';
import 'package:projet_carnet_de_depenses/pages/profile.dart';

import '../models/user.dart';
import '../services/storage.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("TP2"),
        actions: [
          IconButton(
            // test Fase 1 (Manajemen Storage)
            onPressed: () async {
    // 1. Ambil instans kementerian penyimpanan Anda
    final storage = StorageService();

    print("--- MEMULAI PENGUJIAN STORAGE ---");

    // 2. Buat objek User tiruan
    User mockUser = User("Shinnosuke", "Nohara", "assets/shinchan_profil_image.jpeg");

    // 3. TES SIMPAN: Simpan ke dalam storage lokal HP
    storage.saveUser(mockUser);
    print("1. Data user tiruan berhasil diperintahkan untuk disimpan.");

    // 4. TES AMBIL: Ambil kembali data yang baru saja disimpan dari storage
    User? savedUser = storage.getUser();

    // 5. VERIFIKASI HASIL
    if (savedUser != null) {
    print("2. BERHASIL! Data ditemukan di dalam Storage lokal.");
    print("👉 Nama Depan Hasil Decode: ${savedUser.firstName}");
    print("👉 Nama Belakang Hasil Decode: ${savedUser.lastName}");
    print("👉 Path Gambar Hasil Decode: ${savedUser.picture}");
    } else {
    print("❌ GAGAL! Storage mengembalikan nilai null.");
    }

    print("--- PENGUJIAN STORAGE SELESAI ---");
    },
            icon: Icon(
              Icons.account_circle,
              size: 40,
            )
          )
        ],
      )
    );
  }
}

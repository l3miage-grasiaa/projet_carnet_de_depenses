import 'package:flutter/material.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TP1"),), // Parent utama halaman
      body: Center( // Menengahkan isinya
          child: Column( // Menyusun vertikal
            mainAxisAlignment: MainAxisAlignment.center, // Memusatkan isi column
            children: [
              const Text("Selamat tahun baru"), // Widget anak 1
              Image.asset('assets/happyNewYear.gif') // Widget anak 2
            ],
          )
      ),
    );
  }
}

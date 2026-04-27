import 'package:flutter/material.dart';

class MyHome extends StatelessWidget {
  const MyHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TP1"),), // Parent utama halaman
      body: Center( // Menengahkan isinya
          child: Container( // Container sebagai "pembungkus" luar
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(10.0), // Jarak antara bingkai dan isi
            color: Colors.amber[100],

            // Gunakan properti child (tunggal) untuk memasukkan Column
            child: Column( // Menyusun vertikal
              mainAxisSize: MainAxisSize.min, // // Agar column tidak menghabiskan seluruh layar
              children: [
                const Text(
                    "Selamat tahun baru",
                    style: TextStyle(fontWeight: FontWeight.bold),), // Widget anak 1
                Image.asset('assets/happyNewYear.gif') // Widget anak 2
              ],
            ),
          )
      ),
    );
  }
}

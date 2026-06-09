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
              // 1. Vérifiez si un utilisateur est déjà enregistré dans la mémoire du téléphone portable
              User? savedUser = storage.getUser();

              if (savedUser != null) {
                // CONDITION A: L’utilisateur existe déjà -> Accéder directement à la page de profil
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ProfilePage(user: savedUser),
                ));
              } else {
                // CONDITION B: Aucun utilisateur connecté -> Connexion Internet requise
                // Attendre le résultat de LoginPage via Navigator.pop
                var result = await Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const LoginPage(),
                ));

                // Si l'utilisateur se connecte avec succès et récupère l'objet Utilisateur
                if (result != null && result is User) {
                  storage.saveUser(result); // Enregistrer sur le stockage local HP

                  // Après avoir enregistré le profil, accédez directement à la page de profil.
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
        child: Text("Main content app"),
      ),
    );
  }
}
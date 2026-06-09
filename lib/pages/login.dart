import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/user.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // GlobalKey pour controler et valider le status du form UI
  final _formKey = GlobalKey<FormState>();

  // Controller pour attraper les string insérés à temps-réel
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    // fermer les controller pour éviter les fuites de mémoire (memory leak)
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // 1. Validez le formulaire localement avant de le soumettre sur Internet.
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      // 2. Simulation d'authentification dynamique à l'aide de l'API jsonplaceholder
      // Nous rechercherons un utilisateur en fonction de l'adresse e-mail saisie par celui-ci.
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users?email=${_emailController.text.trim()}'),
      ).timeout(const Duration(seconds: 10)); // timeout s'il n'y a pas de réseau

      if (response.statusCode == 200) {
        final List<dynamic> users = jsonDecode(response.body);

        if (users.isNotEmpty) {
          // Si email est trouvé dans la bd de API
          final Map<String, dynamic> userData = users[0];

          User loggedInUser = User(
            userData['name'].toString().split(' ')[0],
            userData['username'],
            userData['email'],
            "assets/shinchan_profil_image.jpeg", // Default avatar project
          );

          if (mounted) {
            Navigator.of(context).pop(loggedInUser); // récuperer user
          }
        } else {
          _showSnackBar("Email inséré n'existe pas dans le système!");
        }
      } else {
        _showSnackBar("Server Error: Erreur de se connecter");
      }
    } catch (e) {
      _showSnackBar("Connection échouée. Vérifiez votre réseau.");
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Gérer mes Dépenses")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.wallet_rounded, size: 80, color: Colors.deepPurple),
                const SizedBox(height: 16),
                const Text(
                  "Carnet de Dépenses",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),

                // --- INPUT EMAIL ---
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: "Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Email ne peut pas être vide.!";
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                      return "Format d'adresse e-mail invalide!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // --- INPUT PASSWORD ---
                TextFormField(
                  controller: _passwordController,
                  obscureText: true, // Censurer les entrées pour les étoiles
                  decoration: const InputDecoration(
                    labelText: "Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Le mot de passe ne peut pas être vide!";
                    }
                    if (value.length < 4) {
                      return "Le mot de passe doit comporter au moins 4 caractères !";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),

                // --- BOUTON SUBMIT ---
                ElevatedButton(
                  onPressed: _isLoading ? null : _handleLogin,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                  ),
                  child: _isLoading
                      ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white))
                      : const Text("Se Connecter (Login)", style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
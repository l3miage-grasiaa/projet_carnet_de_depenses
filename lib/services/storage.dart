import 'dart:convert';

import 'package:localstorage/localstorage.dart';

import '../models/user.dart';

class StorageService {

  static final StorageService _sharedInstance = StorageService._internal();
  factory StorageService() => _sharedInstance;
  StorageService._internal();

  Future<void> init() async {
    await initLocalStorage();
  }

  void saveUser(User user) {
    // Convertit un nouvel objet Utilisateur en une chaîne JSON.
    localStorage.setItem("cached_user", jsonEncode(user.toJson()));
  }

  User? getUser() {
    final rawData = localStorage.getItem('cached_user');
    if (rawData == null) return null;

    try {
      // 1. Décoder le texte brut stocké
      final decoded = jsonDecode(rawData);

      // Si le résultat du décodage est toujours une chaîne de caractères (doublement encodée)
      if (decoded is String) {
        final Map<String, dynamic> actualMap = jsonDecode(decoded);
        return User.fromJson(actualMap);
      }

      // 3. Si le résultat du décodage est correct, il se présente sous la forme de Map.
      if (decoded is Map<String, dynamic>) {
        return User.fromJson(decoded);
      }

      // Si le format n'est pas reconnu, renvoie null.
      return null;
    } catch (e) {
      print("Error saat membaca storage: $e");
      return null;
    }
  }

  void clearUser(){
    localStorage.removeItem("cached_user");
  }
}
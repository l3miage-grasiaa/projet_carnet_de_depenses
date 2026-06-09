import 'dart:convert';

import 'package:localstorage/localstorage.dart';

import '../models/expense.dart';
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
      print("Erreur lors de la lecture du stockage: $e");
      return null;
    }
  }

  void clearUser(){
    localStorage.removeItem("cached_user");
  }


  // 1. Fonction de stockage de tous les enregistrements de dépenses
  void saveExpenses(String userId, List<Expense> expenses) {
    // Convertir List<Expense> en List<Map> via la boucle .map()
    final List<Map<String, dynamic>> mappedList = expenses.map((e) => e.toJson()).toList();

    // Convertir List<Map> en une seule chaîne de caractères à l'aide de jsonEncode
    String stringJson = jsonEncode(mappedList);
    localStorage.setItem('expenses_$userId', stringJson); // CLÉ UNIQUE: Combine le mot «expenses_» avec l’identifiant unique de l’utilisateur provenant de l’API
  }

  // 2. Fonction de récupération de tous les enregistrements de dépenses
  List<Expense> getExpenses(String userId) {
    final rawData = localStorage.getItem('expenses_$userId'); // Lire à partir de la clé unique correspondant à l'utilisateur actuellement actif
    if (rawData == null) return []; // Si vide, renvoie une liste vide.

    try {
      final decoded = jsonDecode(rawData);

      // Gestion anticipée des variations du type de données jsonDecode
      List<dynamic> listMentah = (decoded is String) ? jsonDecode(decoded) : decoded;

      // Convertir les données brutes de la carte en un objet Expense pur
      return listMentah.map((item) => Expense.fromJson(item as Map<String, dynamic>)).toList();
    } catch (e) {
      print("Erreur lors de la lecture de la liste des dépenses: $e");
      return [];
    }
  }
}
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
    localStorage.setItem("cached_user", jsonEncode(user.toJson()));
  }

  User? getUser() {
    final rawData = localStorage.getItem('cached_user');
    if (rawData == null) return null;

    try {
      // 1. Lakukan decode teks mentah dari penyimpanan
      final decoded = jsonDecode(rawData);

      // 2. ANTISIPASI: Jika hasil decode ternyata masih berupa String (double-encoded)
      if (decoded is String) {
        final Map<String, dynamic> actualMap = jsonDecode(decoded);
        return User.fromJson(actualMap);
      }

      // 3. Jika hasil decode sudah benar berupa Map
      if (decoded is Map<String, dynamic>) {
        return User.fromJson(decoded);
      }

      // Jika format tidak dikenali, amankan dengan return null
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
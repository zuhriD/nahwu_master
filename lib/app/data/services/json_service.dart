import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/materi_model.dart';

/// Service untuk membaca dan mem-parse data dari file JSON lokal
class JsonService {
  /// Path ke file JSON materi
  static const String _jsonPath = 'assets/data/materi.json';

  /// Load dan parse materi dari file JSON
  /// Mengembalikan object [Materi] atau throw [Exception] jika gagal
  Future<Materi> loadMateri() async {
    try {
      // Baca file JSON dari assets menggunakan rootBundle
      final String jsonString = await rootBundle.loadString(_jsonPath);

      // Decode JSON string menjadi Map
      final Map<String, dynamic> jsonMap =
          json.decode(jsonString) as Map<String, dynamic>;

      // Parse Map menjadi object Materi
      return Materi.fromJson(jsonMap);
    } catch (e) {
      // Re-throw dengan pesan yang lebih informatif
      throw Exception('Gagal memuat data materi: $e');
    }
  }
}

import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/materi_model.dart';

/// Service untuk membaca dan mem-parse data dari file JSON lokal
class JsonService {
  static const List<String> _babV2Paths = [
    'assets/data/fix_data/bab_kalam_v2_tanda_fiil_sumber_ayat_fix.json',
    'assets/data/fix_data/bab_irab_v2_sumber_lengkap.json',
    'assets/data/fix_data/bab_mengetahui_tanda_tanda_irab_v3_tabel_nashab_khafadh_fix.json',
  ];
  static const String _latihanPath = 'assets/data/latihan.json';

  /// Load dan parse materi dari file JSON
  /// Mengembalikan object [Materi] atau throw [Exception] jika gagal
  Future<Materi> loadMateri() async {
    try {
      final babJson = <Map<String, dynamic>>[];
      final latihanByMateriId = await _loadLatihanByMateriId();

      for (final path in _babV2Paths) {
        final jsonString = await rootBundle.loadString(path);
        final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
        final babId = babJson.length + 1;
        final enrichedJson = _injectLatihan(jsonMap, latihanByMateriId, babId);
        babJson.add({
          ...enrichedJson,
          'id': babId,
        });
      }

      return Materi.fromJson({
        'judul': 'Ilmu Nahwu - Jurumiyah',
        'deskripsi': 'Pengantar ilmu nahwu berdasarkan kitab Jurumiyah',
        'bab': babJson,
      });
    } catch (e) {
      // Re-throw dengan pesan yang lebih informatif
      throw Exception('Gagal memuat data materi: $e');
    }
  }

  Future<Map<String, List<dynamic>>> _loadLatihanByMateriId() async {
    final jsonString = await rootBundle.loadString(_latihanPath);
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    final latihanItems =
        (jsonMap['latihan_soal'] as List<dynamic>? ?? const <dynamic>[]);

    final result = <String, List<dynamic>>{};
    for (final item in latihanItems.whereType<Map<String, dynamic>>()) {
      final materiId = item['materi_id'] as String?;
      if (materiId == null || materiId.isEmpty) continue;
      result[materiId] =
          (item['latihan'] as List<dynamic>? ?? const <dynamic>[]);
    }
    return result;
  }

  Map<String, dynamic> _injectLatihan(
    Map<String, dynamic> babJson,
    Map<String, List<dynamic>> latihanByMateriId,
    int babId,
  ) {
    final subBabList =
        (babJson['sub_bab'] as List<dynamic>? ?? const <dynamic>[])
            .whereType<Map<String, dynamic>>()
            .map((subBab) {
      final materiId = _materiIdForSubBabTitle(subBab['judul'] as String?);
      if (materiId == null) return subBab;

      return {
        ...subBab,
        'parent_bab_id': babId,
        'materi_id': materiId,
        'latihan': latihanByMateriId[materiId] ?? const <dynamic>[],
      };
    }).toList();

    return {
      ...babJson,
      'sub_bab': subBabList,
    };
  }

  String? _materiIdForSubBabTitle(String? title) {
    switch (title) {
      case 'Kalam':
        return 'kalam';
      case 'Pembagian Kata':
        return 'pembagian_kalimah';
      case 'Tanda-Tanda Isim':
        return 'tanda_tanda_isim';
      case 'Tanda-Tanda Fi’il':
        return 'tanda_tanda_fiil';
      case 'Tanda-Tanda Huruf':
        return 'tanda_tanda_huruf';
      case 'I’rab dan Pembagiannya':
        return 'irab_dan_pembagiannya';
      case 'I’rab yang Berlaku pada Isim':
        return 'irab_pada_isim';
      case 'I’rab yang Berlaku pada Fi’il':
        return 'irab_pada_fiil';
      case 'Tanda-Tanda I’rab Rafa’':
        return 'tanda_irab_rafa';
      case 'Tanda-Tanda I’rab Nashab':
        return 'tanda_irab_nashab';
      case 'Tanda-Tanda I’rab Khafadh/Jar':
        return 'tanda_irab_khafad';
      case 'Tanda-Tanda I’rab Jazm':
        return 'tanda_irab_jazm';
      default:
        return null;
    }
  }
}

import 'sub_bab_model.dart';

/// Model untuk Bab - setiap bab dalam kitab Jurumiyah
/// Bab sekarang berisi daftar sub_bab, bukan langsung teks_inti dan latihan
class Bab {
  final int? id;
  final String? judul;
  final String? icon;
  final String? youtubeId;
  final List<SubBab>? subBab;

  Bab({
    this.id,
    this.judul,
    this.icon,
    this.youtubeId,
    this.subBab,
  });

  bool get hasYoutube => youtubeId != null && youtubeId!.isNotEmpty;

  factory Bab.fromJson(Map<String, dynamic> json) {
    return Bab(
      id: json['id'] as int?,
      judul: json['judul'] as String?,
      icon: json['icon'] as String?,
      youtubeId: json['youtube_id'] as String?,
      subBab: json['sub_bab'] != null
          ? (json['sub_bab'] as List<dynamic>)
              .map((e) => SubBab.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'judul': judul,
        'icon': icon,
        'youtube_id': youtubeId,
        'sub_bab': subBab?.map((e) => e.toJson()).toList(),
      };

  /// Helper untuk mendapatkan total latihan dari semua sub_bab
  int get totalLatihan {
    if (subBab == null) return 0;
    return subBab!.fold(0, (sum, sub) => sum + (sub.latihan?.length ?? 0));
  }
}
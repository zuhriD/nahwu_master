import 'latihan_model.dart';
import 'teks_inti_model.dart';

/// Model untuk Bab - setiap bab dalam kitab Jurumiyah
class Bab {
  final int? id;
  final String? judul;
  final String? icon;
  final TeksInti? teksInti;
  final List<Latihan>? latihan;

  Bab({
    this.id,
    this.judul,
    this.icon,
    this.teksInti,
    this.latihan,
  });

  factory Bab.fromJson(Map<String, dynamic> json) {
    return Bab(
      id: json['id'] as int?,
      judul: json['judul'] as String?,
      icon: json['icon'] as String?,
      teksInti: json['teks_inti'] != null
          ? TeksInti.fromJson(json['teks_inti'] as Map<String, dynamic>)
          : null,
      latihan: json['latihan'] != null
          ? (json['latihan'] as List<dynamic>)
              .map((e) => Latihan.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'judul': judul,
        'icon': icon,
        'teks_inti': teksInti?.toJson(),
        'latihan': latihan?.map((e) => e.toJson()).toList(),
      };
}

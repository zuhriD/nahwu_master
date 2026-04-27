import 'latihan_model.dart';
import 'teks_inti_model.dart';
import 'lagu_matan_model.dart';

/// Model untuk SubBab - setiap sub-bab dalam sebuah bab
class SubBab {
  final int? id;
  final String? judul;
  final String? icon;
  final TeksInti? teksInti;
  final LaguMatan? lagu;
  final List<Latihan>? latihan;

  SubBab({
    this.id,
    this.judul,
    this.icon,
    this.teksInti,
    this.lagu,
    this.latihan,
  });

  factory SubBab.fromJson(Map<String, dynamic> json) {
    return SubBab(
      id: json['id'] as int?,
      judul: json['judul'] as String?,
      icon: json['icon'] as String?,
      teksInti: json['teks_inti'] != null
          ? TeksInti.fromJson(json['teks_inti'] as Map<String, dynamic>)
          : null,
      lagu: json['lagu'] != null
          ? LaguMatan.fromJson(json['lagu'] as Map<String, dynamic>)
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
        'lagu': lagu?.toJson(),
        'latihan': latihan?.map((e) => e.toJson()).toList(),
      };
}

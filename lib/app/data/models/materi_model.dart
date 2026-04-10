import 'bab_model.dart';

/// Model utama Materi - merepresentasikan seluruh konten dari file JSON
class Materi {
  final String? judul;
  final String? deskripsi;
  final List<Bab>? bab;

  Materi({
    this.judul,
    this.deskripsi,
    this.bab,
  });

  factory Materi.fromJson(Map<String, dynamic> json) {
    return Materi(
      judul: json['judul'] as String?,
      deskripsi: json['deskripsi'] as String?,
      bab: json['bab'] != null
          ? (json['bab'] as List<dynamic>)
              .map((e) => Bab.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'judul': judul,
        'deskripsi': deskripsi,
        'bab': bab?.map((e) => e.toJson()).toList(),
      };
}

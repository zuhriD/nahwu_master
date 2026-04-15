/// Model untuk Latihan (soal latihan) dalam setiap bab
/// Mendukung tipe: benar_salah, pilihan_ganda, isian, cocokkan
class Latihan {
  final int? id;
  final String? pertanyaan;
  final String tipe; // 'benar_salah' | 'pilihan_ganda' | 'isian' | 'cocokkan'
  final bool? jawaban; // Untuk tipe benar_salah
  final String? jawabanIsian; // Untuk tipe isian
  final List<String>? opsi; // Untuk tipe pilihan_ganda
  final int? jawabanBenarIndex; // Index jawaban benar (pilihan_ganda)
  final Map<String, String>? pasangan; // Untuk tipe cocokkan
  final String? penjelasan;

  Latihan({
    this.id,
    this.pertanyaan,
    this.tipe = 'benar_salah',
    this.jawaban,
    this.jawabanIsian,
    this.opsi,
    this.jawabanBenarIndex,
    this.pasangan,
    this.penjelasan,
  });

  factory Latihan.fromJson(Map<String, dynamic> json) {
    bool? parsedJawabanBool;
    String? parsedJawabanString;

    if (json['jawaban'] != null) {
      if (json['jawaban'] is bool) {
        parsedJawabanBool = json['jawaban'] as bool;
      } else if (json['jawaban'] is String) {
        parsedJawabanString = json['jawaban'] as String;
      }
    }

    return Latihan(
      id: json['id'] as int?,
      pertanyaan: json['pertanyaan'] as String?,
      tipe: json['tipe'] as String? ?? 'benar_salah',
      jawaban: parsedJawabanBool,
      jawabanIsian: parsedJawabanString,
      opsi: json['opsi'] != null
          ? (json['opsi'] as List<dynamic>).map((e) => e.toString()).toList()
          : null,
      jawabanBenarIndex: json['jawaban_benar_index'] as int?,
      pasangan: json['pasangan'] != null ? Map<String, String>.from(json['pasangan']) : null,
      penjelasan: json['penjelasan'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pertanyaan': pertanyaan,
        'tipe': tipe,
        'jawaban': jawaban ?? jawabanIsian,

        'opsi': opsi,
        'jawaban_benar_index': jawabanBenarIndex,
        'pasangan': pasangan,
        'penjelasan': penjelasan,
      };
}

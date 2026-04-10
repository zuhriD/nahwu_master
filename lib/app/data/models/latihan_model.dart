/// Model untuk Latihan (soal latihan benar/salah) dalam setiap bab
class Latihan {
  final int? id;
  final String? pertanyaan;
  final bool? jawaban;
  final String? penjelasan;

  Latihan({
    this.id,
    this.pertanyaan,
    this.jawaban,
    this.penjelasan,
  });

  factory Latihan.fromJson(Map<String, dynamic> json) {
    return Latihan(
      id: json['id'] as int?,
      pertanyaan: json['pertanyaan'] as String?,
      jawaban: json['jawaban'] as bool?,
      penjelasan: json['penjelasan'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'pertanyaan': pertanyaan,
        'jawaban': jawaban,
        'penjelasan': penjelasan,
      };
}

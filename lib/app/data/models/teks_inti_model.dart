/// Model untuk TeksInti - teks utama yang dipelajari dalam setiap bab
class TeksInti {
  final String? arab;
  final String? latin;
  final String? terjemahan;
  final String? penjelasan;

  TeksInti({
    this.arab,
    this.latin,
    this.terjemahan,
    this.penjelasan,
  });

  factory TeksInti.fromJson(Map<String, dynamic> json) {
    return TeksInti(
      arab: json['arab'] as String?,
      latin: json['latin'] as String?,
      terjemahan: json['terjemahan'] as String?,
      penjelasan: json['penjelasan'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'arab': arab,
        'latin': latin,
        'terjemahan': terjemahan,
        'penjelasan': penjelasan,
      };
}

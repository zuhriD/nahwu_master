class TeksInti {
  final String? arab;
  final String? latin;
  final String? terjemahan;
  final Penjelasan? penjelasan;

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
      penjelasan: json['penjelasan'] != null
          ? Penjelasan.fromJson(json['penjelasan'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'arab': arab,
        'latin': latin,
        'terjemahan': terjemahan,
        'penjelasan': penjelasan?.toJson(),
      };
}

class Penjelasan {
  final String? pengantar;
  final List<PoinPenjelasan>? poinPoin;
  final Contoh? contoh;

  Penjelasan({
    this.pengantar,
    this.poinPoin,
    this.contoh,
  });

  factory Penjelasan.fromJson(Map<String, dynamic> json) {
    return Penjelasan(
      pengantar: json['pengantar'] as String?,
      poinPoin: json['poin_poin'] != null
          ? (json['poin_poin'] as List<dynamic>)
              .map((e) => PoinPenjelasan.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      contoh: json['contoh'] != null
          ? Contoh.fromJson(json['contoh'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'pengantar': pengantar,
        'poin_poin': poinPoin?.map((e) => e.toJson()).toList(),
        'contoh': contoh?.toJson(),
      };
}

class PoinPenjelasan {
  final String? icon;
  final String? judul;
  final String? teks;

  PoinPenjelasan({
    this.icon,
    this.judul,
    this.teks,
  });

  factory PoinPenjelasan.fromJson(Map<String, dynamic> json) {
    return PoinPenjelasan(
      icon: json['icon'] as String?,
      judul: json['judul'] as String?,
      teks: json['teks'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'judul': judul,
        'teks': teks,
      };
}

class Contoh {
  final String? arab;
  final String? arti;
  final String? catatan;

  Contoh({
    this.arab,
    this.arti,
    this.catatan,
  });

  factory Contoh.fromJson(Map<String, dynamic> json) {
    return Contoh(
      arab: json['arab'] as String?,
      arti: json['arti'] as String?,
      catatan: json['catatan'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'arab': arab,
        'arti': arti,
        'catatan': catatan,
      };
}

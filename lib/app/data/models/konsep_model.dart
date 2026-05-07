class KonsepNode {
  final String? id;
  final String? ikon;
  final String? warnaIkon;
  final String? judul;
  final String? subJudul;
  final String? kategori;
  final String? ringkasan;
  final KonsepDetail? detail;
  final bool? expandDefault;

  KonsepNode({
    this.id,
    this.ikon,
    this.warnaIkon,
    this.judul,
    this.subJudul,
    this.kategori,
    this.ringkasan,
    this.detail,
    this.expandDefault,
  });

  factory KonsepNode.fromJson(Map<String, dynamic> json) {
    return KonsepNode(
      id: json['id'] as String?,
      ikon: json['ikon'] as String?,
      warnaIkon: json['warna_ikon'] as String?,
      judul: json['judul'] as String?,
      subJudul: json['sub_judul'] as String?,
      kategori: json['kategori'] as String?,
      ringkasan: json['ringkasan'] as String?,
      detail: json['detail'] != null
          ? KonsepDetail.fromJson(json['detail'] as Map<String, dynamic>)
          : null,
      expandDefault: json['expand_default'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'ikon': ikon,
        'warna_ikon': warnaIkon,
        'judul': judul,
        'sub_judul': subJudul,
        'kategori': kategori,
        'ringkasan': ringkasan,
        'detail': detail?.toJson(),
        'expand_default': expandDefault,
      };
}

class KonsepDetail {
  final String? deskripsi;
  final List<String>? syarat;
  final List<String>? ciri;
  final List<ContohItem>? contoh;
  final List<BukanContoh>? bukanContoh;
  final List<Hujah>? timeline;
  final List<Hujah>? fungsi;
  final List<Hujah>? amil;
  final List<HurufItem>? huruf;
  final List<HurufItem>? hurufJar;
  final List<Hujah>? jenisTanwin;
  final List<HurufItem>? jenis;
  final List<Hujah>? amilNashab;
  final List<Hujah>? amilJazm;

  KonsepDetail({
    this.deskripsi,
    this.syarat,
    this.ciri,
    this.contoh,
    this.bukanContoh,
    this.timeline,
    this.fungsi,
    this.amil,
    this.huruf,
    this.hurufJar,
    this.jenisTanwin,
    this.jenis,
    this.amilNashab,
    this.amilJazm,
  });

  factory KonsepDetail.fromJson(Map<String, dynamic> json) {
    return KonsepDetail(
      deskripsi: json['deskripsi'] as String?,
      syarat: (json['syarat'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      ciri: (json['ciri'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      contoh: (json['contoh'] as List<dynamic>?)?.map((e) {
        if (e is String) return ContohItem(arab: e);
        return ContohItem.fromJson(e as Map<String, dynamic>);
      }).toList(),
      bukanContoh: (json['bukan_contoh'] as List<dynamic>?)?.map((e) {
        if (e is String) return BukanContoh(arab: e);
        return BukanContoh.fromJson(e as Map<String, dynamic>);
      }).toList(),
      timeline: (json['timeline'] as List<dynamic>?)?.map((e) {
        if (e is String) return Hujah(nama: e);
        return Hujah.fromJson(e as Map<String, dynamic>);
      }).toList(),
      fungsi: (json['fungsi'] as List<dynamic>?)?.map((e) {
        if (e is String) return Hujah(nama: e);
        return Hujah.fromJson(e as Map<String, dynamic>);
      }).toList(),
      amil: (json['amil'] as List<dynamic>?)?.map((e) {
        if (e is String) return Hujah(nama: e);
        return Hujah.fromJson(e as Map<String, dynamic>);
      }).toList(),
      huruf: (json['huruf'] as List<dynamic>?)?.map((e) {
        if (e is String) return HurufItem(arab: e);
        return HurufItem.fromJson(e as Map<String, dynamic>);
      }).toList(),
      hurufJar: (json['huruf_jar'] as List<dynamic>?)?.map((e) {
        if (e is String) return HurufItem(arab: e);
        return HurufItem.fromJson(e as Map<String, dynamic>);
      }).toList(),
      jenisTanwin: (json['jenis_tanwin'] as List<dynamic>?)?.map((e) {
        if (e is String) return Hujah(nama: e);
        return Hujah.fromJson(e as Map<String, dynamic>);
      }).toList(),
      jenis: (json['jenis'] as List<dynamic>?)?.map((e) {
        if (e is String) return HurufItem(arab: e);
        return HurufItem.fromJson(e as Map<String, dynamic>);
      }).toList(),
      amilNashab: (json['amil_nashab'] as List<dynamic>?)?.map((e) {
        if (e is String) return Hujah(nama: e);
        return Hujah.fromJson(e as Map<String, dynamic>);
      }).toList(),
      amilJazm: (json['amil_jazm'] as List<dynamic>?)?.map((e) {
        if (e is String) return Hujah(nama: e);
        return Hujah.fromJson(e as Map<String, dynamic>);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'deskripsi': deskripsi,
        'syarat': syarat,
        'ciri': ciri,
        'contoh': contoh?.map((e) => e.toJson()).toList(),
        'bukan_contoh': bukanContoh?.map((e) => e.toJson()).toList(),
        'timeline': timeline?.map((e) => e.toJson()).toList(),
        'fungsi': fungsi?.map((e) => e.toJson()).toList(),
        'amil': amil?.map((e) => e.toJson()).toList(),
        'huruf': huruf?.map((e) => e.toJson()).toList(),
        'huruf_jar': hurufJar?.map((e) => e.toJson()).toList(),
        'jenis_tanwin': jenisTanwin?.map((e) => e.toJson()).toList(),
        'jenis': jenis?.map((e) => e.toJson()).toList(),
        'amil_nashab': amilNashab?.map((e) => e.toJson()).toList(),
        'amil_jazm': amilJazm?.map((e) => e.toJson()).toList(),
      };
}

class ContohItem {
  final String? arab;
  final String? arti;
  final String? jenis;
  final String? warnaJenis;

  ContohItem({this.arab, this.arti, this.jenis, this.warnaJenis});

  factory ContohItem.fromJson(Map<String, dynamic> json) {
    return ContohItem(
      arab: json['arab'] as String?,
      arti: json['arti'] as String?,
      jenis: json['jenis'] as String?,
      warnaJenis: json['warna_jenis'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'arab': arab,
        'arti': arti,
        'jenis': jenis,
        'warna_jenis': warnaJenis,
      };
}

class BukanContoh {
  final String? arab;
  final String? alasan;

  BukanContoh({this.arab, this.alasan});

  factory BukanContoh.fromJson(Map<String, dynamic> json) {
    return BukanContoh(
      arab: json['arab'] as String?,
      alasan: json['alasan'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'arab': arab,
        'alasan': alasan,
      };
}

class Hujah {
  final String? nama;
  final String? arab;
  final String? arti;
  final String? warna;

  Hujah({this.nama, this.arab, this.arti, this.warna});

  factory Hujah.fromJson(Map<String, dynamic> json) {
    return Hujah(
      nama: json['nama'] as String?,
      arab: json['arab'] as String?,
      arti: json['arti'] as String?,
      warna: json['warna'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'arab': arab,
        'arti': arti,
        'warna': warna,
      };
}

class HurufItem {
  final String? arab;
  final String? arti;

  HurufItem({this.arab, this.arti});

  factory HurufItem.fromJson(Map<String, dynamic> json) {
    return HurufItem(
      arab: json['arab'] as String?,
      arti: json['arti'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'arab': arab,
        'arti': arti,
      };
}
class TabelModel {
  final String? commentUi;
  final String? tipe;
  final String? orientasi;
  final TabelHeader? header;
  final List<TabelKolom>? kolom;
  final List<TabelBaris>? baris;
  final TabelFooter? footer;

  TabelModel({
    this.commentUi,
    this.tipe,
    this.orientasi,
    this.header,
    this.kolom,
    this.baris,
    this.footer,
  });

  factory TabelModel.fromJson(Map<String, dynamic> json) {
    return TabelModel(
      commentUi: json['_comment_UI'] as String?,
      tipe: json['tipe'] as String?,
      orientasi: json['orientasi'] as String?,
      header: json['header'] != null
          ? TabelHeader.fromJson(json['header'] as Map<String, dynamic>)
          : null,
      kolom: (json['kolom'] as List<dynamic>?)
          ?.map((e) => TabelKolom.fromJson(e as Map<String, dynamic>))
          .toList(),
      baris: (json['baris'] as List<dynamic>?)
          ?.map((e) => TabelBaris.fromJson(e as Map<String, dynamic>))
          .toList(),
      footer: json['footer'] != null
          ? TabelFooter.fromJson(json['footer'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_comment_UI': commentUi,
        'tipe': tipe,
        'orientasi': orientasi,
        'header': header?.toJson(),
        'kolom': kolom?.map((e) => e.toJson()).toList(),
        'baris': baris?.map((e) => e.toJson()).toList(),
        'footer': footer?.toJson(),
      };
}

class TabelHeader {
  final String? label;
  final String? deskripsi;
  final TabelStyle? style;

  TabelHeader({this.label, this.deskripsi, this.style});

  factory TabelHeader.fromJson(Map<String, dynamic> json) {
    return TabelHeader(
      label: json['label'] as String?,
      deskripsi: json['deskripsi'] as String?,
      style: json['style_header'] != null
          ? TabelStyle.fromJson(json['style_header'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'deskripsi': deskripsi,
        'style_header': style?.toJson(),
      };
}

class TabelKolom {
  final String? nama;
  final double? lebar;
  final TabelStyle? style;

  TabelKolom({this.nama, this.lebar, this.style});

  factory TabelKolom.fromJson(Map<String, dynamic> json) {
    return TabelKolom(
      nama: json['nama'] as String?,
      lebar: (json['lebar'] as num?)?.toDouble(),
      style: json['style'] != null
          ? TabelStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'nama': nama,
        'lebar': lebar,
        'style': style?.toJson(),
      };
}

class TabelBaris {
  final List<String>? sel;
  final TabelRowStyle? style;

  TabelBaris({this.sel, this.style});

  factory TabelBaris.fromJson(Map<String, dynamic> json) {
    return TabelBaris(
      sel: (json['sel'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      style: json['style'] != null
          ? TabelRowStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'sel': sel,
        'style': style?.toJson(),
      };
}

class TabelRowStyle {
  final String? warnaBackground;

  TabelRowStyle({this.warnaBackground});

  factory TabelRowStyle.fromJson(Map<String, dynamic> json) {
    return TabelRowStyle(
      warnaBackground: json['warna_background'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'warna_background': warnaBackground,
      };
}

class TabelFooter {
  final String? label;
  final TabelStyle? style;

  TabelFooter({this.label, this.style});

  factory TabelFooter.fromJson(Map<String, dynamic> json) {
    return TabelFooter(
      label: json['label'] as String?,
      style: json['style'] != null
          ? TabelStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'style': style?.toJson(),
      };
}

class TabelStyle {
  final String? warnaBackground;
  final String? warnaTeks;
  final String? textAlign;
  final String? fontWeight;
  final double? fontSize;

  TabelStyle({
    this.warnaBackground,
    this.warnaTeks,
    this.textAlign,
    this.fontWeight,
    this.fontSize,
  });

  factory TabelStyle.fromJson(Map<String, dynamic> json) {
    return TabelStyle(
      warnaBackground: json['warna_background'] as String?,
      warnaTeks: json['warna_teks'] as String?,
      textAlign: json['text_align'] as String?,
      fontWeight: json['font_weight'] as String?,
      fontSize: (json['font_size'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'warna_background': warnaBackground,
        'warna_teks': warnaTeks,
        'text_align': textAlign,
        'font_weight': fontWeight,
        'font_size': fontSize,
      };
}
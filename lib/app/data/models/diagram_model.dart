class DiagramModel {
  final String? commentUi;
  final String? tipe;
  final String? subTipe;
  final DiagramLayout? layout;
  final DiagramCenter? center;
  final List<DiagramNode>? nodes;
  final DiagramAnimasi? animasi;

  DiagramModel({
    this.commentUi,
    this.tipe,
    this.subTipe,
    this.layout,
    this.center,
    this.nodes,
    this.animasi,
  });

  factory DiagramModel.fromJson(Map<String, dynamic> json) {
    return DiagramModel(
      commentUi: json['_comment_UI'] as String?,
      tipe: json['tipe'] as String?,
      subTipe: json['sub_tipe'] as String?,
      layout: json['layout'] != null
          ? DiagramLayout.fromJson(json['layout'] as Map<String, dynamic>)
          : null,
      center: json['center'] != null
          ? DiagramCenter.fromJson(json['center'] as Map<String, dynamic>)
          : null,
      nodes: (json['nodes'] as List<dynamic>?)
          ?.map((e) => DiagramNode.fromJson(e as Map<String, dynamic>))
          .toList(),
      animasi: json['animasi'] != null
          ? DiagramAnimasi.fromJson(json['animasi'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        '_comment_UI': commentUi,
        'tipe': tipe,
        'sub_tipe': subTipe,
        'layout': layout?.toJson(),
        'center': center?.toJson(),
        'nodes': nodes?.map((e) => e.toJson()).toList(),
        'animasi': animasi?.toJson(),
      };
}

class DiagramLayout {
  final String? levelHorizontal;

  DiagramLayout({this.levelHorizontal});

  factory DiagramLayout.fromJson(Map<String, dynamic> json) {
    return DiagramLayout(
      levelHorizontal: json['level_horizontal'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'level_horizontal': levelHorizontal,
      };
}

class DiagramCenter {
  final String? label;
  final String? subLabel;
  final DiagramStyle? style;

  DiagramCenter({this.label, this.subLabel, this.style});

  factory DiagramCenter.fromJson(Map<String, dynamic> json) {
    return DiagramCenter(
      label: json['label'] as String?,
      subLabel: json['sub_label'] as String?,
      style: json['style'] != null
          ? DiagramStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'sub_label': subLabel,
        'style': style?.toJson(),
      };
}

class DiagramNode {
  final String? label;
  final String? subLabel;
  final String? arab;
  final String? waktu;
  final String? tanda;
  final DiagramStyle? style;
  final DiagramConnector? connector;
  final DiagramTooltip? tooltip;

  DiagramNode({
    this.label,
    this.subLabel,
    this.arab,
    this.waktu,
    this.tanda,
    this.style,
    this.connector,
    this.tooltip,
  });

  factory DiagramNode.fromJson(Map<String, dynamic> json) {
    return DiagramNode(
      label: json['label'] as String?,
      subLabel: json['sub_label'] as String?,
      arab: json['arab'] as String?,
      waktu: json['waktu'] as String?,
      tanda: json['tanda'] as String?,
      style: json['style'] != null
          ? DiagramStyle.fromJson(json['style'] as Map<String, dynamic>)
          : null,
      connector: json['connector'] != null
          ? DiagramConnector.fromJson(json['connector'] as Map<String, dynamic>)
          : null,
      tooltip: json['tooltip'] != null
          ? DiagramTooltip.fromJson(json['tooltip'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'sub_label': subLabel,
        'arab': arab,
        'waktu': waktu,
        'tanda': tanda,
        'style': style?.toJson(),
        'connector': connector?.toJson(),
        'tooltip': tooltip?.toJson(),
      };
}

class DiagramStyle {
  final String? warnaLingkaran;
  final String? warnaTeks;
  final double? ukuran;
  final double? fontSize;
  final bool? bold;

  DiagramStyle({
    this.warnaLingkaran,
    this.warnaTeks,
    this.ukuran,
    this.fontSize,
    this.bold,
  });

  factory DiagramStyle.fromJson(Map<String, dynamic> json) {
    return DiagramStyle(
      warnaLingkaran: json['warna_lingkaran'] as String?,
      warnaTeks: json['warna_teks'] as String?,
      ukuran: (json['ukuran'] as num?)?.toDouble(),
      fontSize: (json['font_size'] as num?)?.toDouble(),
      bold: json['bold'] as bool?,
    );
  }

  Map<String, dynamic> toJson() => {
        'warna_lingkaran': warnaLingkaran,
        'warna_teks': warnaTeks,
        'ukuran': ukuran,
        'font_size': fontSize,
        'bold': bold,
      };
}

class DiagramConnector {
  final String? jenis;
  final String? warna;
  final double? tebal;

  DiagramConnector({this.jenis, this.warna, this.tebal});

  factory DiagramConnector.fromJson(Map<String, dynamic> json) {
    return DiagramConnector(
      jenis: json['jenis'] as String?,
      warna: json['warna'] as String?,
      tebal: (json['tebal'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
        'jenis': jenis,
        'warna': warna,
        'tebal': tebal,
      };
}

class DiagramTooltip {
  final String? header;
  final String? deskripsi;
  final String? contoh;
  final String? bukanContoh;

  DiagramTooltip({
    this.header,
    this.deskripsi,
    this.contoh,
    this.bukanContoh,
  });

  factory DiagramTooltip.fromJson(Map<String, dynamic> json) {
    return DiagramTooltip(
      header: json['header'] as String?,
      deskripsi: json['deskripsi'] as String?,
      contoh: json['contoh'] as String?,
      bukanContoh: json['bukan_contoh'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'header': header,
        'deskripsi': deskripsi,
        'contoh': contoh,
        'bukan_contoh': bukanContoh,
      };
}

class DiagramAnimasi {
  final bool? animated;
  final String? arah;
  final int? durasiMs;

  DiagramAnimasi({this.animated, this.arah, this.durasiMs});

  factory DiagramAnimasi.fromJson(Map<String, dynamic> json) {
    return DiagramAnimasi(
      animated: json['animated'] as bool?,
      arah: json['arah'] as String?,
      durasiMs: json['durasi_ms'] as int?,
    );
  }

  Map<String, dynamic> toJson() => {
        '派': animated,
        'arah': arah,
        'durasi_ms': durasiMs,
      };
}
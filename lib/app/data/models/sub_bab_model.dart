import 'latihan_model.dart';
import 'teks_inti_model.dart';
import 'lagu_matan_model.dart';
import 'diagram_model.dart';
import 'konsep_model.dart';
import 'tabel_model.dart';

/// Model untuk SubBab - setiap sub-bab dalam sebuah bab
class SubBab {
  final int? id;
  final String? judul;
  final String? icon;
  final int? parentBabId;
  final TeksInti? teksInti;
  final List<TeksInti> teksIntiList;
  final DiagramModel? diagram;
  final Map<String, KonsepNode>? konsepMap;
  final List<KonsepNode>? konsep;
  final TabelModel? tabel;
  final LaguMatan? lagu;
  final List<Latihan>? latihan;
  final Map<String, dynamic> rawJson;

  SubBab({
    this.id,
    this.judul,
    this.icon,
    this.parentBabId,
    this.teksInti,
    this.teksIntiList = const [],
    this.diagram,
    this.konsepMap,
    this.konsep,
    this.tabel,
    this.lagu,
    this.latihan,
    this.rawJson = const {},
  });

  factory SubBab.fromJson(Map<String, dynamic> json) {
    // Handle konsep as map or direct list
    Map<String, KonsepNode>? konsepMapData;
    List<KonsepNode>? konsepListData;

    if (json['konsep'] != null) {
      if (json['konsep'] is Map &&
          (json['konsep'] as Map).containsKey('kartu')) {
        // Handle { tipe: "card_list", layout: "...", kartu: [...] }
        final konsepJson = json['konsep'] as Map<String, dynamic>;
        konsepListData = (konsepJson['kartu'] as List<dynamic>?)
            ?.map((e) => KonsepNode.fromJson(e as Map<String, dynamic>))
            .toList();
      } else if (json['konsep'] is List) {
        konsepListData = (json['konsep'] as List<dynamic>)
            .map((e) => KonsepNode.fromJson(e as Map<String, dynamic>))
            .toList();
      }
    }

    final teksIntiItems = <TeksInti>[];
    final teksIntiJson = json['teks_inti'];
    if (teksIntiJson is List) {
      teksIntiItems.addAll(teksIntiJson
          .whereType<Map<String, dynamic>>()
          .map(TeksInti.fromJson));
    } else if (teksIntiJson is Map<String, dynamic>) {
      teksIntiItems.add(TeksInti.fromJson(teksIntiJson));
    }

    return SubBab(
      id: json['id'] as int?,
      judul: json['judul'] as String?,
      icon: json['icon'] as String?,
      parentBabId: json['parent_bab_id'] as int?,
      teksInti: teksIntiItems.isNotEmpty ? teksIntiItems.first : null,
      teksIntiList: teksIntiItems,
      diagram: json['diagram'] != null
          ? DiagramModel.fromJson(json['diagram'] as Map<String, dynamic>)
          : null,
      konsepMap: konsepMapData,
      konsep: konsepListData,
      tabel: json['tabel'] != null
          ? TabelModel.fromJson(json['tabel'] as Map<String, dynamic>)
          : null,
      lagu: json['lagu'] != null
          ? LaguMatan.fromJson(json['lagu'] as Map<String, dynamic>)
          : null,
      latihan: json['latihan'] != null
          ? (json['latihan'] as List<dynamic>)
              .map((e) => Latihan.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      rawJson: json,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'judul': judul,
        'icon': icon,
        'parent_bab_id': parentBabId,
        'teks_inti': teksIntiList.length > 1
            ? teksIntiList.map((e) => e.toJson()).toList()
            : teksInti?.toJson(),
        'diagram': diagram?.toJson(),
        'konsep': konsep?.map((e) => e.toJson()).toList(),
        'tabel': tabel?.toJson(),
        'lagu': lagu?.toJson(),
        'latihan': latihan?.map((e) => e.toJson()).toList(),
      };

  List<KonsepNode> get allKonsep {
    if (konsep != null) return konsep!;
    if (konsepMap != null) return konsepMap!.values.toList();
    return [];
  }

  bool get hasDiagram => diagram != null;
  bool get hasKonsep => allKonsep.isNotEmpty;
  bool get hasTabel =>
      tabel != null && tabel!.kolom != null && tabel!.baris != null;

  int? get progressId {
    if (parentBabId == null || id == null) return id;
    return (parentBabId! * 100) + id!;
  }

  String? get materialAudioPath {
    final audio = rawJson['audio'];
    if (audio is Map<String, dynamic>) {
      return audio['asset_path'] as String?;
    }
    return null;
  }

  String? get materialAudioTitle {
    final audio = rawJson['audio'];
    if (audio is Map<String, dynamic>) {
      return audio['title'] as String?;
    }
    return null;
  }

  Map<String, dynamic>? get videoData {
    final video = rawJson['video'];
    if (video is Map<String, dynamic>) {
      return video;
    }
    return null;
  }

  String? get videoTitle => videoData?['title'] as String?;
  String? get youtubeUrl => videoData?['youtube_url'] as String?;
  String? get youtubeId => videoData?['youtube_id'] as String?;

  Map<String, dynamic>? get mindMapData {
    final mindMap = rawJson['mind_map'];
    if (mindMap is Map<String, dynamic>) {
      return mindMap;
    }
    return null;
  }

  String? get mindMapTitle => mindMapData?['title'] as String?;
  String? get mindMapImagePath => mindMapData?['image_path'] as String?;
  String? get mindMapAlt => mindMapData?['alt'] as String?;
}

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
  final TeksInti? teksInti;
  final DiagramModel? diagram;
  final Map<String, KonsepNode>? konsepMap;
  final List<KonsepNode>? konsep;
  final TabelModel? tabel;
  final LaguMatan? lagu;
  final List<Latihan>? latihan;

  SubBab({
    this.id,
    this.judul,
    this.icon,
    this.teksInti,
    this.diagram,
    this.konsepMap,
    this.konsep,
    this.tabel,
    this.lagu,
    this.latihan,
  });

  factory SubBab.fromJson(Map<String, dynamic> json) {
    // Handle konsep as map or direct list
    Map<String, KonsepNode>? konsepMapData;
    List<KonsepNode>? konsepListData;

    if (json['konsep'] != null) {
      if (json['konsep'] is Map && (json['konsep'] as Map).containsKey('kartu')) {
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

    return SubBab(
      id: json['id'] as int?,
      judul: json['judul'] as String?,
      icon: json['icon'] as String?,
      teksInti: json['teks_inti'] != null
          ? TeksInti.fromJson(json['teks_inti'] as Map<String, dynamic>)
          : null,
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
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'judul': judul,
        'icon': icon,
        'teks_inti': teksInti?.toJson(),
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
  bool get hasTabel => tabel != null;
}

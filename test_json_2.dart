import 'dart:convert';
import 'dart:io';

void main() {
  final file = File('assets/data/materi.json');
  final jsonString = file.readAsStringSync();
  final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
  final babList = jsonMap['bab'] as List<dynamic>;
  for (var b in babList) {
    final subBabList = b['sub_bab'] as List<dynamic>?;
    if (subBabList != null) {
      for (var s in subBabList) {
        print('Bab ${b['id']} SubBab ${s['id']} has konsep? ${s['konsep'] != null}');
        final konsep = s['konsep'];
        if (konsep != null) {
          if (konsep is Map) {
            final kartu = konsep['kartu'];
            print('  konsep is Map, kartu is ${kartu.runtimeType}');
            if (kartu is List) {
              for (var i = 0; i < kartu.length; i++) {
                if (kartu[i] is! Map<String, dynamic>) {
                  print('  kartu[$i] is ${kartu[i].runtimeType}');
                }
              }
            }
          }
        }
      }
    }
  }
}

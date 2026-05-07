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
        final konsep = s['konsep'];
        if (konsep != null && konsep is Map && konsep.containsKey('kartu')) {
          final kartu = konsep['kartu'] as List<dynamic>?;
          if (kartu != null) {
            for (var k in kartu) {
              if (k is! Map<String, dynamic>) {
                 print('Found it: $k');
              }
              // What if there is something inside k that is broken?
              final detail = k['detail'];
              if (detail != null && detail is Map) {
                 for (final key in detail.keys) {
                   if (detail[key] is List) {
                     for (var item in detail[key]) {
                        if (item is! Map<String, dynamic> && item is! String) {
                           print('Item in detail $key is: ${item.runtimeType} -> $item');
                        }
                        if (item is String && key != 'syarat') {
                           print('Found String where Map expected in detail $key: $item');
                        }
                     }
                   }
                 }
              }
            }
          }
        }
      }
    }
  }
}

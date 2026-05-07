import 'dart:convert';
import 'dart:io';
import 'lib/app/data/models/materi_model.dart';

void main() {
  try {
    final file = File('assets/data/materi.json');
    final jsonString = file.readAsStringSync();
    final jsonMap = json.decode(jsonString) as Map<String, dynamic>;
    Materi.fromJson(jsonMap);
    print('Success!');
  } catch (e, stacktrace) {
    print('Error: $e');
    print(stacktrace);
  }
}

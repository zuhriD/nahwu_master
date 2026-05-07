import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:mockito/mockito.dart';

import 'package:jurumiyah_app/app/modules/home/views/home_view.dart';
import 'package:jurumiyah_app/app/modules/home/controllers/home_controller.dart';
import 'package:jurumiyah_app/app/modules/detail/views/detail_view.dart';
import 'package:jurumiyah_app/app/modules/detail/controllers/detail_controller.dart';
import 'package:jurumiyah_app/app/modules/lagu_matan/views/lagu_matan_view.dart';
import 'package:jurumiyah_app/app/modules/lagu_matan/controllers/lagu_matan_controller.dart';
import 'package:jurumiyah_app/app/data/local/storage_service.dart';
import 'package:jurumiyah_app/app/data/models/bab_model.dart';
import 'package:jurumiyah_app/app/data/models/sub_bab_model.dart';

class MockStorage extends Mock implements StorageService {
  @override
  bool isBabRead(int id) => false;
  @override
  bool isQuizDone(int id) => false;
  @override
  bool isBookmarked(int id) => false;
  @override
  int getBestScore(int id) => 0;
  @override
  int getTotalXp() => 0;
  @override
  List<int> getBookmarkedBabIds() => [];
  @override
  List<int> getBookmarkedSubBabIds() => [];
  @override
  bool getThemeMode() => false;
}

void main() {
  testWidgets('Test layout of DetailView', (WidgetTester tester) async {
    FlutterError.onError = (FlutterErrorDetails details) {
      print('FLUTTER_ERROR_START');
      print(details.exception);
      print('FLUTTER_ERROR_END');
    };

    final mockStorage = MockStorage();
    Get.put<StorageService>(mockStorage);

    final bab = Bab(
      id: 1,
      judul: 'Bab 1',
      icon: 'icon',
      youtubeId: 'abc',
      subBab: [],
    );

    await tester.pumpWidget(GetMaterialApp(
      home: Scaffold(
        body: Builder(builder: (context) {
          return ElevatedButton(
            onPressed: () => Get.to(() => const DetailView(), arguments: bab),
            child: const Text('Go'),
          );
        }),
      ),
    ));

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();
  });
}

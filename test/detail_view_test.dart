import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jurumiyah_app/app/data/models/bab_model.dart';
import 'package:jurumiyah_app/app/modules/detail/views/detail_view.dart';
import 'package:get/get.dart';

void main() {
  testWidgets('DetailView renders without overflow', (WidgetTester tester) async {
    // Provide a dummy Bab
    final bab = Bab(
      id: 1,
      judul: 'Bab 1',
      icon: 'icon',
      youtubeId: 'abc',
      subBab: [],
    );

    await tester.pumpWidget(
      GetMaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  Get.to(() => const DetailView(), arguments: bab);
                },
                child: const Text('Go'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('Go'));
    await tester.pumpAndSettle();
    
    expect(find.byType(DetailView), findsOneWidget);
  });
}

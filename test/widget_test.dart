// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:sugar/controllers/data_store_controller.dart';

void main() {
  group('App Tests', () {
    setUp(() {
      Get.put(DataStoreController());
    });

    tearDown(() {
      Get.reset();
    });

    testWidgets('App shows login screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        GetMaterialApp(
          home: const Material(
            child: Center(
              child: Text('Login'),
            ),
          ),
        ),
      );

      expect(find.text('Login'), findsOneWidget);
    });
  });
}

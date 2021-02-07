import 'package:flutter/material.dart';
import 'package:myportion_app/services/helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Validate Name', () {
    test('Good Name', () {
      String returnVal = validateName("John Luke");
      expect(returnVal, null);
    });

    test('Bad Name', () {
      String returnVal = validateName("1John Luke");
      expect(returnVal, "Name must be a-z and A-Z");
    });

    test('No Name', () {
      String returnVal = validateName("");
      expect(returnVal, "Name is required");
    });
  });

  group('Validate Mobile', () {});

  group('Validate Password', () {});

  group('Notification Alert Tests', () {
    testWidgets('Notification Alert Builds with Correct Text',
        (WidgetTester tester) async {
      Builder(builder: (BuildContext context) {
        showAlertDialog(context, 'Title', 'Content');
        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Content'), findsOneWidget);
        expect(find.text('Does not Exist'), findsNothing);
        return Placeholder();
      });
    });
    testWidgets('Notification Alert Exists Only in Context',
        (WidgetTester tester) async {
      Builder(builder: (BuildContext context) {
        showAlertDialog(context, 'Title', 'Content');
        return Placeholder();
      });
      expect(find.text('Title'), findsNothing);
      expect(find.text('Content'), findsNothing);
    });
  });
}

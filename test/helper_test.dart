import 'package:flutter/material.dart';
import 'package:myportion_app/services/helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportion_app/ui/signUp/SignUpScreen.dart';
//import '../lib/ui/signUp/SignUpScreen.dart';
//import 'package:cached_network_image/cached_network_image.dart';

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

  group('Progress Dialog Tests', () {
    testWidgets('Progress Dialog Builds with Correct Text',
        (WidgetTester tester) async {
      Builder(builder: (BuildContext context) {
        showProgress(context, 'Message', false);
        expect(find.text('Message'), findsOneWidget);
        expect(find.text('Does not Exist'), findsNothing);
        return Placeholder();
      });
    });

    testWidgets('Progress Dialog Exists Only in Context',
        (WidgetTester tester) async {
      Builder(builder: (BuildContext context) {
        showProgress(context, 'Message', false);
        return Placeholder();
      });
      expect(find.text('Title'), findsNothing);
      expect(find.text('Content'), findsNothing);
    });

    testWidgets('Progress Dialog Update Progress', (WidgetTester tester) async {
      Builder(builder: (BuildContext context) {
        showProgress(context, 'Message', false);
        expect(find.text('Message'), findsOneWidget);
        updateProgress('NewMessage');
        expect(find.text('Message'), findsNothing);
        expect(find.text('NewMessage'), findsOneWidget);
        return Placeholder();
      });
    });

    testWidgets('Progress Dialog Hide Progress', (WidgetTester tester) async {
      Builder(builder: (BuildContext context) {
        showProgress(context, 'Message', false);
        expect(find.text('Message'), findsOneWidget);
        hideProgress();
        expect(find.text('Message'), findsNothing);
        return Placeholder();
      });
    });
  });

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

  /* group('Push Utilities', () {
    testWidgets('Push Creates View',
        (WidgetTester tester) async {
      Builder(builder: (BuildContext context) {
        push(context, new SignUpScreen);
        expect(find.byWidget(SignUpScreen), findsNothing);
        return Placeholder();
      });
    });
  }); */
  /* group('displayCircleImage Tests', () {
    testWidgets('displayCircleImage has image', (WidgetTester tester) async {
      await tester.pumpWidget(
          displayCircleImage('/assets/images/placeholder.jpg', 20, false));
      expectLater(find.byType(CachedNetworkImage),
          matchesGoldenFile('../assets/images/placeholder.jpg'));
    });
    /* testWidgets('displayCircleImage has no image', (WidgetTester tester) async {
      await tester.pumpWidget(displayCircleImage('', 20, false));
      expect(find.byType(ClipOval), findsOneWidget);
    }); */
  }); */
}

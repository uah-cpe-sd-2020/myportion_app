import 'package:flutter/material.dart';
import 'package:myportion_app/services/helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myportion_app/ui/signUp/SignUpScreen.dart';
import 'package:myportion_app/ui/auth/AuthScreen.dart';

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

  group('Validate Mobile', () {
    test('Good Number', () {
      String returnVal = validateMobile("1234567890");
      expect(returnVal, null);
    });

    test('Bad Number', () {
      String returnVal = validateMobile("abc");
      expect(returnVal, "Mobile phone number must contain only digits");
    });

    test('No Number', () {
      String returnVal = validateMobile("");
      expect(returnVal, "Mobile phone number is required");
    });

    /* Might need requirement of US numbers only
    test('Short Number', () {
      String returnVal = validateMobile("123");
      expect(returnVal, "Mobile phone number must contain 9 digits");
    });
     */
  });

  group('Validate Password', () {
    test('Good Password', () {
      String returnVal = validatePassword("abc123!@#JKL");
      expect(returnVal, null);
    });

    test('Short Password', () {
      String returnVal = validatePassword("password");
      expect(returnVal, "Password must be more than 10 characters");
    });

    /* Might want to require symbols, numbers, and caps
    test('Bad Password', () {
      String returnVal = validatePassword("passwordpassword");
      expect(returnVal, "Password does not contain a symbol, number, a capitol");
    });
    */

    test('No Password', () {
      String returnVal = validatePassword("");
      expect(returnVal, "Password must be more than 10 characters");
    });
  });

  group('Validate Email', () {
    test('Good Email', () {
      String returnVal = validateEmail("email@gmail.com");
      expect(returnVal, null);
    });

    /* Not necessary if we send validation emails to the address provided
    test('Strange but valid email', () {
      String returnVal = validateEmail("very.\”(),:;<>[]\”.VERY.\”very@\\ \"very\”.unusual@strange.example.com");
      expect(returnVal, null);
    });
     */

    test('No @ character', () {
      String returnVal = validateEmail("abc.example.com");
      expect(returnVal, "Enter Valid Email");
    });

    test('Too many @ characters', () {
      String returnVal = validateEmail("A@b@c@example.com");
      expect(returnVal, "Enter Valid Email");
    });

    test('Invalid special characters', () {
      String returnVal = validateEmail("a\"b(c)d,e:f;g<h>i[j\\k]l@example.com");
      expect(returnVal, "Enter Valid Email");
    });

    test('Quotes not supported', () {
      String returnVal = validateEmail("just\"not\"right@example.com");
      expect(returnVal, "Enter Valid Email");
    });

    test('Cannot contain spaces, quotes, or backslashes', () {
      String returnVal = validateEmail("this is\"not\\allowed@example.com");
      expect(returnVal, "Enter Valid Email");
    });

    test('Invalid Domain Name', () {
      String returnVal = validateEmail("test@example..com");
      expect(returnVal, "Enter Valid Email");
    });

    test('IP Not Supported', () {
      String returnVal = validateEmail("test@192.168.0.1");
      expect(returnVal, "Enter Valid Email");
    });

    test('No Email', () {
      String returnVal = validateEmail("");
      expect(returnVal, "Enter Valid Email");
    });
  });

  group('Validate Confirm Email', () {
    test('Matching Password', () {
      String returnVal =
          validateConfirmPassword("abc123!@#JKL", "abc123!@#JKL");
      expect(returnVal, null);
    });
  });

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

  group('Push Utilities', () {
    testWidgets('Push Creates View in Right Context',
        (WidgetTester tester) async {
      Builder(builder: (BuildContext context) {
        push(context, new SignUpScreen());
        expect(find.byType(SignUpScreen), findsOneWidget);
        return Placeholder();
      });
      expect(find.byType(SignUpScreen), findsNothing);
    });

    testWidgets('PushReplacement Changes View in Right Context',
        (WidgetTester tester) async {
      Builder(builder: (BuildContext context) {
        push(context, new SignUpScreen());
        pushReplacement(context, new AuthScreen());
        expect(find.byType(SignUpScreen), findsNothing);
        expect(find.byType(AuthScreen), findsOneWidget);
        return Placeholder();
      });
      expect(find.byType(AuthScreen), findsNothing);
    });

    testWidgets('PushAndRemoveUntil Changes View in Right Context',
        (WidgetTester tester) async {
      Builder(builder: (BuildContext context) {
        push(context, new SignUpScreen());
        pushAndRemoveUntil(context, AuthScreen(), false);
        expect(find.byType(SignUpScreen), findsNothing);
        expect(find.byType(AuthScreen), findsOneWidget);
        return Placeholder();
      });
      expect(find.byType(AuthScreen), findsNothing);
    });
  });

  group('displayCircleImage Tests', () {
    testWidgets('displayCircleImage has provided image',
        (WidgetTester tester) async {
      await tester.pumpWidget(
          displayCircleImage('/assets/images/placeholder.jpg', 20, false));
      expectLater(find.byKey(Key("cachedImg")), findsOneWidget);
    });

    testWidgets('displayCircleImage has no provided image',
        (WidgetTester tester) async {
      await tester.pumpWidget(displayCircleImage('', 20, false));
      expectLater(find.byKey(Key("cachedImg")), findsOneWidget);
    });
  });
}

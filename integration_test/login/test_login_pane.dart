import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import '../lib/test_lib_common.dart';
import '../lib/test_lib_const.dart';
import 'test_login_const.dart';

class LoginPane {
  static Future<void> verify(WidgetTester tester, String context) async {
    await tester.pumpAndSettle();
    await htExpect(tester, find.byKey(testEmailKey), findsOneWidget,
        reason:
            (verifyStr + "-" + context + "-" + 'Email field on Login screen'));
    await htExpect(tester, find.byKey(testPasswordKey), findsOneWidget,
        reason: (verifyStr +
            "-" +
            context +
            "-" +
            'Password field on Login screen'),
        dopns: false);
    await htExpect(
      tester,
      find.byKey(testSigninKey),
      findsOneWidget,
      reason:
          (verifyStr + "-" + context + "-" + 'SignIN button on Login screen'),
      dopns: false,
    );
    await htExpect(tester, find.text('Forgot password?'), findsOneWidget,
        reason: (verifyStr +
            "-" +
            context +
            "-" +
            'Forgot password button on Login screen'),
        dopns: false);
    await htExpect(tester, find.byKey(testSignupKey), findsOneWidget,
        reason:
            (verifyStr + "-" + context + "-" + 'SignUP button on Login screen'),
        dopns: false);
  }

  static Future<String> getEmail() async {
    return find.byKey(testEmailKey).toString();
  }

  static Future<void> setEmailValue(WidgetTester tester, String str,
      {String context = ""}) async {
    await writeSomething(tester, find.byKey(testEmailKey), str,
        addContext(context, "Setting the email field"));
  }

  static Future<String> getPasswordValue() async {
    var password = find.byKey(testPasswordKey);
    return password.toString();
  }

  static Future<void> setPasswordValue(WidgetTester tester, String str,
      {String context = ""}) async {
    await writeSomething(tester, find.byKey(testPasswordKey), str,
        addContext(context, "Setting the password field"));
  }

  static Future<void> tapSignIn(WidgetTester tester,
      {String context = ""}) async {
    await tapSomething(tester, find.byKey(testSigninKey),
        addContext(context, "Tap Signin Button"));
  }

  static Future<void> tapVisibilityIsOffIcon(WidgetTester tester,
      {String context = ""}) async {
    await tapSomething(tester, find.byIcon(testVisivilityOff),
        addContext(context, "Tap Visibility Off Button"));
  }

  static Future<void> tapVisibilityIsOnIcon(WidgetTester tester,
      {String context = ""}) async {
    await tapSomething(tester, find.byIcon(testVisivilityOn),
        addContext(context, "Tap Visibility Button"));
  }

  static Future<void> run(WidgetTester tester,
      [String? username, String? password, String? context]) async {
    await tester.pumpAndSettle();
    username = username ?? envUserName;
    password = password ?? envUserPassword;
    context = context ?? "";

    await setEmailValue(tester, username, context: context);
    await setPasswordValue(tester, password, context: context);
    await tapSignIn(tester, context: context);
  }
}

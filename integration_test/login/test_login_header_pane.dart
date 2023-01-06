import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'test_login_const.dart';
import '../lib/test_lib_const.dart';
import '../lib/test_lib_common.dart';
import 'package:flutter/gestures.dart';

class LoginHeaderPane {
  static Future<void> logout(WidgetTester tester, {String context = ""}) async {
    var logout;
    await tester.pumpAndSettle();
    //TODO  Delay to see changes
    // await addDelay(10);
    // logout = find.byKey(logoutKey);

    await tester.pumpAndSettle();
    tapMenuListItemByKey(tester, find.byKey(testLogoutKey),
        // "Logout",
        context: context,
        rightButton: false,
        closeMenu: false);
    await tester.pumpAndSettle();

    // await tester.ensureVisible(logout);
    // await tester.pumpAndSettle();
    // await tester.tap(logout);
    // await tester.pumpAndSettle();
    //TODO Delay to see changes
    // await addDelay(10);
  }

  static Future<void> _tapMenuIcon(WidgetTester tester,
      {String context = ""}) async {
    await tapSomething(
        tester,
        // find.byKey(testIconMenu),
        ////TODO find menu by key
        find.byIcon(testIconMenu),
        addContext(context, "Tap Menu Button"),
        ignoreException: ignoreTestException);
  }

  static Future<void> _closeMenu(WidgetTester tester,
      {String context = "",
      bool ignoreException(WidgetTester tester, var e) =
          justIgnoreException}) async {
    // Swipe the item to dismiss it.
    await tester.drag(find.byType(Dismissible), const Offset(500.0, 0.0));
    await tester.pumpAndSettle();
    await verify(tester, context: addContext(context, "Verify menu is closed"));
  }

  // Future<void> _tapFolderIcon(WidgetTester tester,
  //     {bool ignoreException(WidgetTester tester, var e) = justIgnoreException,
  //     bool rightButton = false}) async {
  //   await tapSomething(tester, find.byIcon(Icons.folder), "Tap Folder Button",
  //       ignoreException: ignoreException);
  // }

//   Future<void> expectMenuListItem(WidgetTester tester, String searchString,
//       {dynamic matcher = findsOneWidget, bool closeMenu = false}) async {
// // Problem is ensuring the menu is close, opening the menu and then closing it again.
// // When testing forms, it was solved by tapping the FormBuilder icon. With Login
// // we don't know what is or isn't there. It comes down to tapping something else.

//     // await this._tapFolderIcon(tester, ignoreException: ignoreTestException);
//     await this._tapMenuIcon(tester);
//     await qexpect(tester, find.text(searchString), matcher,
//         reason: "Find $searchString in forms templates",
//         ignoreException: ignoreTestException);
//     if (closeMenu)
//       await _closeMenu(tester, ignoreException: ignoreTestException);

//     //   await this._tapFolderIcon(tester, ignoreException: ignoreTestException);
//   }

//   Future<void> tapMenuListItem(WidgetTester tester, String searchString,
//       {bool rightButton = false, bool closeMenu = false}) async {
//     // await this._tapFolderIcon(tester, ignoreException: ignoreTestException);
//     await this._tapMenuIcon(tester);

//     String rightStr = rightButton ? 'Right' : 'Left';
//     await tapSomething(tester, find.text(searchString),
//         "Tap $rightStr $searchString in forms templates",
//         rightButton: rightButton, ignoreException: ignoreTestException);

//     if (closeMenu)
//       await _closeMenu(tester, ignoreException: ignoreTestException);
//     // if (closeMenu)
//     //   await this._tapFolderIcon(tester, ignoreException: ignoreTestException);
//   }

  static Future<void> expectMenuListItemByKey(
      WidgetTester tester, Finder search,
      {String context = "",
      dynamic matcher = findsOneWidget,
      bool closeMenu = false}) async {
// Problem is ensuring the menu is close, opening the menu and then closing it again.
// When testing forms, it was solved by tapping the FormBuilder icon. With Login
// we don't know what is or isn't there. It comes down to tapping something else.

    await _tapMenuIcon(tester, context: context);
    await qexpect(tester, search, matcher,
        reason: addContext(
            context, "Find " + search.toString() + " in forms templates"),
        ignoreException: ignoreTestException);
    if (closeMenu)
      await _closeMenu(tester,
          context: context, ignoreException: ignoreTestException);
  }

  static Future<void> tapMenuListItemByKey(WidgetTester tester, Finder search,
      {String context = "",
      bool rightButton = false,
      bool closeMenu = false}) async {
    await _tapMenuIcon(tester, context: context);

    String rightStr = rightButton ? 'Right' : 'Left';
    await tapSomething(
        tester,
        search,
        addContext(context,
            "Tap $rightStr " + search.toString() + " in forms templates"),
        rightButton: rightButton,
        ignoreException: ignoreTestException);

    if (closeMenu)
      await _closeMenu(tester,
          context: context, ignoreException: ignoreTestException);
  }

  static Future<void> verify(WidgetTester tester, {String context = ""}) async {
    await qexpect(
      tester,
      find.byIcon(testIconMenu),
      findsOneWidget,
      reason: addContext(context, 'Menu button on header'),
      dopns: false,
    );
  }
}

import 'package:flutter_test/flutter_test.dart';
import '../../lib/main.dart' as app;
import '../lib/test_lib_common.dart';
import 'test_login_pane.dart';

const String testUserName = "joe@noone.ca";
const String testPassword = "abc123";

const String testDescription = 'Login password visibility tests';
const String testPassed = "Passed";
const String testFailed = "Failed";

void main() async {
  await htTestInit(description: testDescription);
  htTestWidgets((WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await LoginPane.setEmailValue(tester, testUserName);
    await LoginPane.setPasswordValue(tester, testPassword);

    String passwordValue = await LoginPane.getPasswordValue();
    await htExpect(tester, (passwordValue != testPassword), true,
        reason: "Password not visible by default");

    await LoginPane.tapVisibilityIsOffIcon(tester);

    passwordValue = await LoginPane.getPasswordValue();
    await htExpect(tester, (passwordValue == testPassword), true,
        reason: "Password visible after tap Visibility icon button");

    await LoginPane.tapVisibilityIsOnIcon(tester);

    passwordValue = await LoginPane.getPasswordValue();
    await htExpect(tester, (passwordValue != testPassword), true,
        reason: "Password not visible after tap Visibility Off icon button");
    await htTestEnd(tester);
  });
}

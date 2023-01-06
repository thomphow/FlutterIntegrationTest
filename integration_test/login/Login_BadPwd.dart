import 'package:flutter_test/flutter_test.dart';
import '../../lib/main.dart' as app;
import '../lib/test_lib_common.dart';
import 'test_login_pane.dart';

const String testValidUserName = "howard@fandemand.ca";
const String testInValidPassword = "abc123";

const String testDescription = 'Login exception for invalid password';
const String passwordException =
    'The password is invalid or the user does not have a password.';

void main() async {
  await htTestInit(description: testDescription);
  htTestWidgets((WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await LoginPane.setEmailValue(tester, testValidUserName);
    await LoginPane.setPasswordValue(tester, testInValidPassword);
    await LoginPane.tapSignIn(tester);
    await htExpect(tester, find.text(passwordException), findsOneWidget,
        reason: "Invalid password Exception Pop-up Message");
    await htTestEnd(tester);
  });
}

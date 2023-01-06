import 'package:flutter_test/flutter_test.dart';
import '../../lib//main.dart' as app;
// import 'lib/test_lib_auto.dart';
import '../lib/test_lib_common.dart';
import 'test_login_pane.dart';

const String testInvalidUserName = "joe@noone.ca";
const String testInvalidPassword = "abc123";

const String testDescription = 'Login exceptions for invalid user name';
const String userNameException =
    'There is no user record corresponding to this identifier. The user may have been deleted.';

void main() async {
  await htTestInit(description: testDescription);
  htTestWidgets((WidgetTester tester) async {
    app.main();
    await tester.pumpAndSettle();
    await LoginPane.setEmailValue(tester, testInvalidUserName);
    await LoginPane.setPasswordValue(tester, testInvalidPassword);
    await LoginPane.tapSignIn(tester);
    await htExpect(tester, find.text(userNameException), findsOneWidget,
        reason: "Invalid User Name Exception Pop-up Message");
    await htTestEnd(tester);
  });
}

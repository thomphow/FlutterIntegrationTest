import 'package:flutter_test/flutter_test.dart';
import '../../lib/main.dart' as app;
import '../lib/test_lib_common.dart';
import 'test_login_header_pane.dart';
import 'test_login_pane.dart';

void main() async {
  const String testDescription = 'Confirm Login and Logout';
  await htTestInit(description: testDescription);
  htTestWidgets((WidgetTester tester) async {
    app.main();
    await LoginPane.verify(tester, "First Login");
    await LoginPane.run(tester);
    await LoginHeaderPane.logout(tester);
    await addDelay(15);
    await LoginPane.verify(tester, "Post Logout");
    await htTestEnd(tester);
  });
}

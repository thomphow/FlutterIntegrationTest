import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:stack_trace/stack_trace.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:integration_test/src/channel.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'test_lib_const.dart';

IntegrationTestWidgetsFlutterBinding? forScreenshotBinding;

// Also has parm milliseconds
Future<void> addDelay(int s) async {
  await Future<void>.delayed(Duration(seconds: s));
}

void htTestWidgets(
  WidgetTesterCallback callback, {
  bool? skip,
  Duration? initialTimeout,
  bool semanticsEnabled = true,
  TestVariant<Object?> variant = const DefaultTestVariant(),
  dynamic tags,
}) =>
    testWidgets((callback as WidgetTester).testDescription, callback);

Future<void> htExpect(WidgetTester tester, dynamic actual, dynamic matcher,
    {String? reason,
    dynamic skip,
    bool dopns = true,
    bool doBefore = true,
    bool ignoreException(WidgetTester tester, var e) =
        justIgnoreException}) async {
  // expect(actual, matcher, reason: (reason ?? "Missing Reason"), skip: skip );
  if (dopns) await tester.pumpAndSettle();
  if (doBefore) await qlogBefore(tester, (reason ?? "Missing Reason"));
  expect(actual, matcher,
      reason:
          '@=@=,\"$testcaseNum\",\"${tester.testDescription}\",\"${(reason ?? "Missing Reason")}\",FAILED,@+@+',
      skip: skip);
  await htLogResultWithExceptionCheck(
      tester, (reason ?? "Missing Reason"), ignoreException);
}

void ignoreSomeErrors(
  FlutterErrorDetails details, {
  bool forceReport = false,
}) {
  bool ifIsOverflowError = false;
  bool isUnableToLoadAsset = false;
  bool isErrorWidget = false;
  var exception = details.exception;
  if (exception is FlutterError) {
    ifIsOverflowError = exception.diagnostics.any(
      (e) => e.value.toString().startsWith("A RenderFlex overflowed by"),
    );
    isUnableToLoadAsset = exception.diagnostics.any(
      (e) => e.value.toString().startsWith("Unable to load asset"),
    );
    isErrorWidget = exception.diagnostics.any(
      (e) => e.value.toString().startsWith("The value of ErrorWidget.builder"),
    );
  }
  if (ifIsOverflowError || isUnableToLoadAsset || isErrorWidget) {
    debugPrint('Ignorred Error');
  } else {
    FlutterError.presentError(details);
  }
}

String testcaseNum = "unknown - please call qtestInit()";

Future<void> htTestInit(
    {String description = "No Test Name Provided",
    bool isDesktop = false,
    int testNameStackIndex = 4}) async {
  // Use the file name as the test case number, picking the name off the stack
  testcaseNum = Trace.current()
      .frames[testNameStackIndex]
      .library
      .replaceAll(".dart", "");

  // To debug init file name problems
  print("******* START TRACEBACK *****" + Trace.current().frames.toString());
  print("******* START TRACEBACK *****");

  await htLogdDirect(description, "", "STARTED");

  FlutterError.onError = ignoreSomeErrors;

  const _deskTopSize = Size(3840, 2160); // physical pixels

  forScreenshotBinding = IntegrationTestWidgetsFlutterBinding();
  forScreenshotBinding?.framePolicy =
      LiveTestWidgetsFlutterBindingFramePolicy.fullyLive;

  final WidgetsBinding binding =
      IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  // final Size logicalViewport = binding.window.physicalSize / binding.window.devicePixelRatio;
  if (isDesktop)
    binding.renderView.configuration =
        TestViewConfiguration(size: _deskTopSize);
}

Future<void> htTestEnd(WidgetTester tester) async {
  await htLogd(tester, tester.testDescription, "", "FINISHED");
  forScreenshotBinding?.reset();
  addDelay(3);
}

Future<void> htLogdDirect(
    String description, String message, String result) async {
  print('@-@-,\"$testcaseNum\",\"$description\",\"$message\",\"$result\",@|@|');
  await addDelay(1);
}

Future<void> htLogd(WidgetTester tester, String description, String message,
    String result) async {
  tester.printToConsole(
      '@-@-,\"$testcaseNum\",\"$description\",\"$message\",\"$result\",@|@|');
  await addDelay(1);
}

Future<void> htLog(WidgetTester tester, String message,
    {String? result, bool? passed}) async {
  String finalResult = result ?? "Result not set";

  if (passed != null) {
    finalResult = passed ? "Passed" : "Failed";
    if (!passed) {
      await takeScreenshot(tester, message);
    }
  }

  await htLogd(tester, tester.testDescription, message, finalResult);
}

Future<void> qlogBefore(WidgetTester tester, String message) async {
  await htLog(tester, message, result: "BEFORE");
}

bool justIgnoreException(WidgetTester tester, var e) {
  return false;
}

Future<void> htLogResultWithExceptionCheck(WidgetTester tester, String message,
    [bool ignoreException(WidgetTester tester, var e) =
        justIgnoreException]) async {
  var e = tester.takeException();
  String result = "Passed";
  if (e != null) {
    if (ignoreException(tester, e)) {
      tester.printToConsole(
          '@=@=,\"$testcaseNum\",\"${tester.testDescription}\",\"$message\",\"IGNORED EXCEPTION\",@+@+');
    } else {
      tester.printToConsole(
          '@=@=,\"$testcaseNum\",\"${tester.testDescription}\",\"$message\",\"${e.toString()}\",@+@+');
      result = "Failed";
      await takeScreenshot(tester, message);
    }
  }

  tester.printToConsole(
      '@=@=,\"$testcaseNum\",\"${tester.testDescription}\",\"$message\",\"$result\",@+@+');
  await addDelay(1);
}

String addContext(String context, String reason) {
  return context + "-" + reason;
}

Future<void> tapSomething(WidgetTester tester, Finder place, String reason,
    {bool ignoreException(WidgetTester tester, var e) = justIgnoreException,
    bool rightButton = false}) async {
  await qlogBefore(tester, reason);
  await tester.ensureVisible(place);
  await tester.pumpAndSettle();
  int button = rightButton ? kSecondaryMouseButton : kPrimaryButton;
  await tester.tap(place, buttons: button);
  await tester.pumpAndSettle();
  await htLogResultWithExceptionCheck(tester, reason, ignoreException);
}

Future<void> writeSomething(
    WidgetTester tester, Finder place, String str, String reason,
    [bool ignoreException(WidgetTester tester, var e) =
        justIgnoreException]) async {
  await qlogBefore(tester, reason);
  await tester.ensureVisible(place);
  await tester.pumpAndSettle();
  await tester.tap(place);
  await tester.enterText(place, str);
  await tester.pumpAndSettle();
  await htLogResultWithExceptionCheck(tester, reason, ignoreException);
}

Future<String> readSomething(WidgetTester tester, Finder place, String reason,
    [bool ignoreException(WidgetTester tester, var e) =
        justIgnoreException]) async {
  await qlogBefore(tester, reason);
  await tester.ensureVisible(place);
  await tester.pumpAndSettle();
  var text = tester.firstWidget(place);
  await htLogResultWithExceptionCheck(tester, reason, ignoreException);
  return text.toString();
}

bool ignoreTestException(WidgetTester tester, var e) {
  // expect(tester.takeException(), isInstanceOf<UnrecognizedTermException>());
  print("******** EXCEPTION ******" + e.toString());
  // return (e is String);
  return true;

  // ******** EXCEPTION 1 ****** "Multiple exceptions (3) were detected during the running of the current test, and at least one was unexpected."
  // It turns out that all we are passed is a string as listed above from the integration test framework. Which is completely useless.

  // ******** EXCEPTION 2 ******The provided ScrollController is currently attached to more than one ScrollPosition.
  // The Scrollbar requires a single ScrollPosition in order to be painted.
  // When the scrollbar is interactive, the associated Scrollable widgets must have unique ScrollControllers. The provided ScrollController must be unique to a Scrollable widget.
}

Future<void> _drag(WidgetTester tester, Key startKey, Key targetKey) async {
  await tester.pumpAndSettle();
  Finder start = find.byKey(startKey);
  Finder target = find.byKey(targetKey);
  final Offset off = tester.getCenter(start);
  final TestGesture? drag = await tester.startGesture(off);
  final Offset topLeft = tester.getTopLeft(target);
  await drag?.moveTo(topLeft);
  await drag?.up();
  await tester.pumpAndSettle();
}

Future<void> dragNExpect(WidgetTester tester, Key startKey, Key targetKey,
    String reason, String locPrefix, int field,
    {bool ignoreException(WidgetTester tester, var e) =
        justIgnoreException}) async {
  await qlogBefore(tester, reason);
  await _drag(tester, startKey, targetKey);
  Key key = Key('${locPrefix}${field.toString()}');
  Finder place = find.byKey(key);
  await tester.ensureVisible(place);
  await htExpect(tester, place, findsOneWidget,
      reason: reason, doBefore: false, ignoreException: ignoreException);
}

// Mostly taken from https://github.com/flutter/flutter/issues/92381

Future<void> _takeScreenshotForAndroid(
    IntegrationTestWidgetsFlutterBinding binding, String name) async {
  await integrationTestChannel.invokeMethod<void>(
    'convertFlutterSurfaceToImage',
    null,
  );
  binding.reportData ??= <String, dynamic>{};
  binding.reportData!['screenshots'] ??= <dynamic>[];
  integrationTestChannel.setMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'scheduleFrame':
        PlatformDispatcher.instance.scheduleFrame();
        break;
    }
    return null;
  });
  final List<int>? rawBytes =
      await integrationTestChannel.invokeMethod<List<int>>(
    'captureScreenshot',
    <String, dynamic>{'name': name},
  );
  if (rawBytes == null) {
    throw StateError(
        'Expected a list of bytes, but instead captureScreenshot returned null');
  }
  final Map<String, dynamic> data = {
    'screenshotName': name,
    'bytes': rawBytes,
  };
  assert(data.containsKey('bytes'));
  (binding.reportData!['screenshots'] as List<dynamic>).add(data);

  await integrationTestChannel.invokeMethod<void>(
    'revertFlutterImage',
    null,
  );
}

Future<void> _takeScreenshot(WidgetTester tester,
    IntegrationTestWidgetsFlutterBinding binding, String name) async {
  await tester.pumpAndSettle();
  // Need test for KIsWeb first because
  // isAndroid throws Unsupported operation: Platform._operatingSystem
  // Howard
  if (kIsWeb) {
    await binding.takeScreenshot(name);
  } else if (Platform.isAndroid) {
    await _takeScreenshotForAndroid(binding, name);
  } else {
    await binding.takeScreenshot(name);
  }
  print("Took screenshot: $name");
}

Future<void> takeScreenshot(WidgetTester tester, String name) async {
  if (forScreenshotBinding != null)
    await _takeScreenshot(
        tester, forScreenshotBinding!, testcaseNum + "-" + name);
  else
    print("Screenshot Binding is null - " + name);
}

Future<void> tapBackIcon(WidgetTester tester,
    {bool ignoreException(WidgetTester tester, var e) =
        justIgnoreException}) async {
  await tapSomething(tester, find.byKey(testBackKey), "Tap Button",
      ignoreException: ignoreTestException);
}

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

// Passing test in parameters from environment
const String defaultUserName = 'howard@howardthompson.ca';
const String defaultUserPassword = 'justtesting';
const String envUserName =
    String.fromEnvironment('TEST_USER_NAME', defaultValue: defaultUserName);
const String envUserPassword = String.fromEnvironment('TEST_USER_PASSWORD',
    defaultValue: defaultUserPassword);

const String verifyStr = "Verify";

const Key testEmailKey = Key('emailKey');
const Key testPasswordKey = Key('passwordKey');
const Key testLogoutKey = Key('logoutKey');
const Key testSigninKey = Key('signinKey');
const Key testBackKey = Key('backButton');

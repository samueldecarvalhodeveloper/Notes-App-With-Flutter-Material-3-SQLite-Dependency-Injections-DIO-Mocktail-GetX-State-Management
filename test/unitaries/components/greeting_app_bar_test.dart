import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:notes_app/components/greeting_app_bar.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/constants/user_interface_constants.dart";

void main() {
  group("Test Component GreetingAppBar", () {});
  testWidgets("Test If Component Displays Greeting Message With Username", (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(appBar: GreetingAppBar(USER_USERNAME))),
    );

    Finder greetingAppBarWidget = find.text(
      TOP_BAR_GREETING_TITLE_TEXT(USER_USERNAME),
    );

    expect(greetingAppBarWidget, findsOneWidget);
  });
}

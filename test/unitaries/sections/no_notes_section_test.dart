import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:notes_app/constants/user_interface_constants.dart";
import "package:notes_app/sections/no_notes_section.dart";

void main() {
  group("Test Section NoNotesSection", () {
    testWidgets("Test If \"No notes\" Label Is Displayed", (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: NoNotesSection())),
      );

      expect(find.text(NO_NOTES_LABEL_TEXT), findsOneWidget);
    });
  });
}

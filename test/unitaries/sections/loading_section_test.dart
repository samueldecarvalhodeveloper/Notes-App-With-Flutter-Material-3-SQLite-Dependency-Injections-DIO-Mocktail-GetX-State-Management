import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:notes_app/sections/loading_section.dart";
import "package:notes_app/constants/user_interface_constants.dart";

void main() {
  group("Test Section LoadingSection", () {
    testWidgets("Test If Loading Progress Indicator Is Displayed", (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: LoadingSection())),
      );

      expect(find.bySemanticsLabel(LOADING_SECTION_TOOLTIP), findsOneWidget);
    });
  });
}

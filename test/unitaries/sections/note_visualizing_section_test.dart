import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/sections/note_visualizing_section.dart";

void main() {
  group("Test Section NoteVisualizingSection", () {
    testWidgets("Test If Note Data Is Displayed", (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(body: NoteVisualizingSection(note: NOTE_MODEL_OBJECT)),
        ),
      );

      expect(find.text(NOTE_TITLE), findsOneWidget);
      expect(find.text(NOTE_BODY), findsOneWidget);
    });
  });
}

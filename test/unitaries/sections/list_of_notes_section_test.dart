import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/sections/list_of_notes_section.dart";

void main() {
  group("Test Section ListOfNotesSection", () {
    testWidgets("Test If List Of Notes Is Displayed And Items Are Tappable", (
      WidgetTester tester,
    ) async {
      bool isWidgetTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListOfNotesSection(
              listOfNotes: [NOTE_MODEL_OBJECT],
              onNoteItemClick: (int id) {
                isWidgetTapped = !isWidgetTapped;
              },
            ),
          ),
        ),
      );

      expect(find.text(NOTE_TITLE), findsOneWidget);

      await tester.tap(find.text(NOTE_TITLE));

      expect(isWidgetTapped, isTrue);
    });
  });
}

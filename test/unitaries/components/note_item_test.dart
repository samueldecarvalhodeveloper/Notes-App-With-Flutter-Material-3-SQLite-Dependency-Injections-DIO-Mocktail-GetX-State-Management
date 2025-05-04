import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:notes_app/components/note_item.dart";
import "package:notes_app/constants/note_constants.dart";

void main() {
  group("Test ComponentNoteItem", () {
    testWidgets(
      "Test If Component Displays Note Title And Body; And Triggers On Click When Tapped",
      (WidgetTester tester) async {
        bool isWidgetTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NoteItem(
                title: NOTE_TITLE,
                body: NOTE_BODY,
                onTap: () {
                  isWidgetTapped = true;
                },
              ),
            ),
          ),
        );

        await tester.tap(find.text(NOTE_TITLE));

        expect(isWidgetTapped, isTrue);
      },
    );
  });
}

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/sections/note_editing_section.dart";

void main() {
  group("Test Section NoteEditingSection", () {
    testWidgets(
      "Test If Note Data Is Displayed And Dispatches Title And Body Actions On Text Change",
      (WidgetTester tester) async {
        bool isTitleTextChanged = false;
        bool isBodyTextChanged = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: NoteEditingSection(
                note: NOTE_MODEL_OBJECT,
                onNoteTitleChange: (_) {
                  isTitleTextChanged = true;
                },
                onNoteBodyChange: (_) {
                  isBodyTextChanged = true;
                },
              ),
            ),
          ),
        );

        await tester.enterText(find.widgetWithText(TextField, NOTE_TITLE), "");

        await tester.enterText(find.widgetWithText(TextField, NOTE_BODY), "");

        expect(isTitleTextChanged, isTrue);
        expect(isBodyTextChanged, isTrue);
      },
    );
  });
}

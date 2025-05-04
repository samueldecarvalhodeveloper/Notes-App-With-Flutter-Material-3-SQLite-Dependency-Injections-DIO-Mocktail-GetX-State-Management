import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/controllers/note_editing_controller.dart";
import "package:notes_app/repositories/note_repository.dart";
import "package:notes_app/screens/note_editing_screen.dart";
import "../mocks/note_repository_mock.dart";

void main() {
  group("Test User Interface Getting Note Integration", () {
    late NoteRepository noteRepository;
    late NoteEditingController noteEditingController;

    testWidgets("Test User Interface Getting Note", (
      WidgetTester tester,
    ) async {
      noteRepository = NoteRepositoryMock();

      when(() => noteRepository.getNote(NOTE_ID)).thenAnswer((_) async {
        return NOTE_MODEL_OBJECT;
      });

      noteEditingController = NoteEditingController(noteRepository);

      noteEditingController.note.value = NOTE_MODEL_OBJECT;

      noteEditingController.isNoteLoaded.value = true;

      await tester.pumpWidget(
        MaterialApp(
          home: NoteManipulatingScreen(NOTE_ID, noteEditingController, () {}),
        ),
      );

      expect(find.text(NOTE_TITLE), findsOneWidget);
      expect(find.text(NOTE_BODY), findsOneWidget);
    });
  });
}

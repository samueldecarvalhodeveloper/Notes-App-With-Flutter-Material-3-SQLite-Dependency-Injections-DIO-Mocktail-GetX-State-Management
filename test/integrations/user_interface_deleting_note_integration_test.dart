import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/constants/user_interface_constants.dart";
import "package:notes_app/controllers/note_editing_controller.dart";
import "package:notes_app/infrastructure/models/note.dart";
import "package:notes_app/repositories/note_repository.dart";
import "package:notes_app/screens/note_editing_screen.dart";
import "../mocks/note_repository_mock.dart";

void main() {
  group("Test User Interface Deleting Note Integration", () {
    late NoteRepository noteRepository;
    late NoteEditingController noteEditingController;

    testWidgets("Test User Interface Deleting Note", (
      WidgetTester tester,
    ) async {
      bool isNoteDeleted = false;

      noteRepository = NoteRepositoryMock();

      noteEditingController = NoteEditingController(noteRepository);

      noteEditingController.note.value = NOTE_MODEL_OBJECT;

      noteEditingController.isNoteLoaded.value = true;

      when(
        () => noteRepository.deleteNote(NOTE_ID, USER_ID),
      ).thenAnswer((_) async {});

      when(() => noteRepository.getNotes()).thenAnswer((_) async {
        return [];
      });

      await tester.pumpWidget(
        MaterialApp(
          home: NoteManipulatingScreen(NOTE_ID, noteEditingController, () {
            isNoteDeleted = true;
          }),
        ),
      );

      await tester.tap(find.byTooltip(DELETE_NOTE_TOOLTIP));

      List<Note> listOfNotesFromDatabase = await noteRepository.getNotes();

      expect(listOfNotesFromDatabase.length, 0);

      expect(isNoteDeleted, isTrue);
    });
  });
}

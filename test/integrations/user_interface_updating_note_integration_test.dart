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
  late NoteRepository noteRepository;
  late NoteEditingController noteEditingController;

  group("Test User Interface Updating Note Integration", () {
    testWidgets("Test User Interface Updating Note", (
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

      await tester.tap(find.byTooltip(EDIT_NOTE_TOOLTIP));

      await tester.pump();

      await tester.enterText(find.text(NOTE_TITLE), "");
      await tester.enterText(find.text(NOTE_BODY), "");

      await tester.tap(find.byTooltip(CONCLUDE_NOTE_BUTTON_TOOLTIP));

      when(() => noteRepository.getNote(NOTE_ID)).thenAnswer((_) async {
        return NOTE_ENTITY_WITH_WRONG_DATA_OBJECT.getModel();
      });

      Note updatedNote = await noteRepository.getNote(NOTE_ID);

      expect(updatedNote.id, NOTE_ID);
      expect(updatedNote.title, "");
      expect(updatedNote.body, "");
      expect(updatedNote.createdAt, NOTE_CREATED_AT);
      expect(updatedNote.updatedAt, NOTE_UPDATED_AT);
      expect(updatedNote.userId, USER_ID);
    });
  });
}

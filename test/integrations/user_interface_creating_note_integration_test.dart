import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/constants/user_interface_constants.dart";
import "package:notes_app/controllers/notes_listing_controller.dart";
import "package:notes_app/infrastructure/models/note.dart";
import "package:notes_app/repositories/note_repository.dart";
import "package:notes_app/repositories/user_repository.dart";
import "package:notes_app/controllers/user_controller.dart";
import "package:notes_app/screens/notes_listing_screen.dart";
import "../mocks/note_repository_mock.dart";
import "../mocks/user_repository_mock.dart";

void main() {
  group("Test User Interface Creating Note Integration", () {
    late NoteRepository noteRepository;
    late UserRepository userRepository;
    late NotesListingController notesListingController;
    late UserController userController;

    testWidgets("Test User Interface Creating Note", (
      WidgetTester tester,
    ) async {
      int? createdNoteOnServiceId = null;

      userRepository = UserRepositoryMock();
      noteRepository = NoteRepositoryMock();

      userController = UserController(userRepository);
      notesListingController = NotesListingController(noteRepository);

      userController.user.value = USER_MODEL_OBJECT;

      notesListingController.isListOfNotesLoaded.value = true;

      when(() => noteRepository.getCreatedNote("", "", USER_ID)).thenAnswer((
        _,
      ) async {
        return NOTE_MODEL_OBJECT;
      });

      when(() => noteRepository.getNote(NOTE_ID)).thenAnswer((_) async {
        return NOTE_ENTITY_WITH_WRONG_DATA_OBJECT.getModel();
      });

      await tester.pumpWidget(
        MaterialApp(
          home: NotesListingScreen(notesListingController, userController, (
            noteId,
          ) {
            createdNoteOnServiceId = noteId;
          }),
        ),
      );

      await tester.tap(find.text(CREATE_NOTE_FLOATING_ACTION_BUTTON_TEXT));

      Note createdNote = await noteRepository.getNote(NOTE_ID);

      expect(createdNote.id, NOTE_ID);
      expect(createdNote.title, "");
      expect(createdNote.body, "");
      expect(createdNote.createdAt, NOTE_CREATED_AT);
      expect(createdNote.updatedAt, NOTE_UPDATED_AT);
      expect(createdNote.userId, USER_ID);

      expect(createdNoteOnServiceId, NOTE_ID);
    });
  });
}

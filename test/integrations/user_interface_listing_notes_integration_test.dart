import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:get/get.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/controllers/notes_listing_controller.dart";
import "package:notes_app/repositories/note_repository.dart";
import "package:notes_app/repositories/user_repository.dart";
import "package:notes_app/controllers/user_controller.dart";
import "package:notes_app/screens/notes_listing_screen.dart";
import "../mocks/note_repository_mock.dart";
import "../mocks/user_repository_mock.dart";

void main() {
  group("Test User Interface Listing Notes Integration", () {
    late NoteRepository noteRepository;
    late UserRepository userRepository;
    late NotesListingController notesListingController;
    late UserController userController;

    testWidgets("Test User Interface Listing Notes", (
      WidgetTester tester,
    ) async {
      userRepository = UserRepositoryMock();
      noteRepository = NoteRepositoryMock();

      userController = UserController(userRepository);
      notesListingController = NotesListingController(noteRepository);

      userController.user.value = USER_MODEL_OBJECT;

      notesListingController.listOfNotes = [NOTE_MODEL_OBJECT].obs;

      notesListingController.isListOfNotesLoaded.value = true;

      await tester.pumpWidget(
        MaterialApp(
          home: NotesListingScreen(
            notesListingController,
            userController,
            (noteId) {},
          ),
        ),
      );

      expect(find.text(NOTE_TITLE), findsOneWidget);
      expect(find.text(NOTE_BODY), findsOneWidget);
    });
  });
}

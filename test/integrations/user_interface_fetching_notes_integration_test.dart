import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
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
  group("Test User Interface Fetching Notes Integration", () {
    late NoteRepository noteRepository;
    late UserRepository userRepository;
    late NotesListingController notesListingController;
    late UserController userController;

    testWidgets("Test User Interface Fetching Notes From Service", (
      WidgetTester tester,
    ) async {
      userRepository = UserRepositoryMock();
      noteRepository = NoteRepositoryMock();

      when(
        () => noteRepository.fetchNotesFromService(USER_ID),
      ).thenAnswer((_) async {});

      when(() => noteRepository.getNotes()).thenAnswer((_) async {
        return [NOTE_MODEL_OBJECT];
      });

      userController = UserController(userRepository);
      notesListingController = NotesListingController(noteRepository);

      userController.user.value = USER_MODEL_OBJECT;

      await tester.pumpWidget(
        MaterialApp(
          home: NotesListingScreen(
            notesListingController,
            userController,
            (noteId) {},
          ),
        ),
      );

      await tester.pump();

      expect(find.text(NOTE_TITLE), findsOneWidget);
      expect(find.text(NOTE_BODY), findsOneWidget);
    });
  });
}

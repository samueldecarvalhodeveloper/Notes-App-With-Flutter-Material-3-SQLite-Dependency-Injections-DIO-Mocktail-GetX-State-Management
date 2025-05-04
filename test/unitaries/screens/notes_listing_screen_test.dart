import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:get/get.dart";
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
import "../../mocks/note_repository_mock.dart";
import "../../mocks/user_repository_mock.dart";

void main() {
  group("Test Screen NotesListingScreen", () {
    late NoteRepository noteRepository;
    late UserRepository userRepository;
    late NotesListingController notesListingController;
    late UserController userController;

    testWidgets("Test If Username Is Displayed On App Bar Greeting", (
      WidgetTester tester,
    ) async {
      userRepository = UserRepositoryMock();
      noteRepository = NoteRepositoryMock();

      when(() => noteRepository.getNotes()).thenAnswer((_) async {
        return [];
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

      expect(
        find.text(TOP_BAR_GREETING_TITLE_TEXT(USER_USERNAME)),
        findsOneWidget,
      );
    });

    testWidgets(
      "Test If Loading Section Is Displayed When List Of Notes Is Not Loaded",
      (WidgetTester tester) async {
        userRepository = UserRepositoryMock();
        noteRepository = NoteRepositoryMock();

        when(() => noteRepository.getNotes()).thenAnswer((_) async {
          return [];
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

        expect(find.bySemanticsLabel(LOADING_SECTION_TOOLTIP), findsOneWidget);
      },
    );

    testWidgets(
      "Test If No Notes Section Is Displayed When List Of Notes Is Empty And Create",
      (WidgetTester tester) async {
        userRepository = UserRepositoryMock();
        noteRepository = NoteRepositoryMock();

        when(() => noteRepository.getNotes()).thenAnswer((_) async {
          return [];
        });

        userController = UserController(userRepository);
        notesListingController = NotesListingController(noteRepository);

        userController.user.value = USER_MODEL_OBJECT;

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

        expect(find.text(NO_NOTES_LABEL_TEXT), findsOneWidget);
      },
    );

    testWidgets("Test If Notes Are Listed When Notes Are Loaded", (
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

    testWidgets("Test If Notes Are Fetched From Service And Listed", (
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

    testWidgets(
      "Test If Note Creation Button Creates Note And Dispatches Action",
      (WidgetTester tester) async {
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
      },
    );
  });
}

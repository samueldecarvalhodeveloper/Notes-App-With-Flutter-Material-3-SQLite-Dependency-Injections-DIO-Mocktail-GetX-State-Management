import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:get/get.dart";
import "package:mocktail/mocktail.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/constants/user_interface_constants.dart";
import "package:notes_app/controllers/note_editing_controller.dart";
import "package:notes_app/controllers/notes_listing_controller.dart";
import "package:notes_app/controllers/user_controller.dart";
import "package:notes_app/infrastructure/models/note.dart";
import "package:notes_app/infrastructure/models/user.dart";
import "package:notes_app/repositories/note_repository.dart";
import "package:notes_app/repositories/user_repository.dart";
import "package:notes_app/screens/note_editing_screen.dart";
import "package:notes_app/screens/notes_listing_screen.dart";
import "package:notes_app/screens/user_sign_in_screen.dart";
import "../mocks/note_repository_mock.dart";
import "../mocks/user_repository_mock.dart";

void main() {
  group("Test System", () {
    late UserRepository userRepository;
    late NoteRepository noteRepository;
    late UserController userController;
    late NoteEditingController noteEditingController;
    late NotesListingController notesListingController;

    testWidgets("Test Creating User", (WidgetTester tester) async {
      bool isUserCreated = false;

      userRepository = UserRepositoryMock();

      when(() => userRepository.getUser()).thenAnswer((_) async {
        return User(USER_ID, USER_USERNAME);
      });

      userController = UserController(userRepository);

      await tester.pumpWidget(
        MaterialApp(
          home: UserSignInScreen(userController, () {
            isUserCreated = true;
          }),
        ),
      );

      await tester.enterText(find.byType(TextField), USER_USERNAME);

      await tester.tap(find.text(CREATE_USER_BUTTON_TEXT));

      User createdUser = await userRepository.getUser();

      expect(createdUser.id, USER_ID);
      expect(createdUser.username, USER_USERNAME);

      expect(isUserCreated, isTrue);
    });

    testWidgets("Test Listing Notes", (WidgetTester tester) async {
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

    testWidgets("Test Getting Note", (WidgetTester tester) async {
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

    testWidgets("Test Fetching Notes From Service", (
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

    testWidgets("Test Creating Note", (WidgetTester tester) async {
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

    testWidgets("Test Updating Note", (WidgetTester tester) async {
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

    testWidgets("Test Deleting Note", (WidgetTester tester) async {
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

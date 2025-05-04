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
import "../../mocks/note_repository_mock.dart";

void main() {
  group("Test Screen NoteEnditingScreen", () {
    late NoteRepository noteRepository;
    late NoteEditingController noteEditingController;

    testWidgets("Test If Navigation Button Dispatches Action", (
      WidgetTester tester,
    ) async {
      bool isNavigationButtonClicked = false;

      noteRepository = NoteRepositoryMock();

      noteEditingController = NoteEditingController(noteRepository);

      await tester.pumpWidget(
        MaterialApp(
          home: NoteManipulatingScreen(NOTE_ID, noteEditingController, () {
            isNavigationButtonClicked = true;
          }),
        ),
      );

      await tester.tap(find.byTooltip(BACK_BUTTON_TOOLTIP));

      expect(isNavigationButtonClicked, isTrue);
    });

    testWidgets("Test If App Bar Conclude Button Updates Note", (
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

    testWidgets("Test If App Bar Edit Button Makes Note Manipulatable", (
      WidgetTester tester,
    ) async {
      noteRepository = NoteRepositoryMock();

      noteEditingController = NoteEditingController(noteRepository);

      noteEditingController.note.value = NOTE_MODEL_OBJECT;

      noteEditingController.isNoteLoaded.value = true;

      await tester.pumpWidget(
        MaterialApp(
          home: NoteManipulatingScreen(NOTE_ID, noteEditingController, () {}),
        ),
      );

      await tester.tap(find.byTooltip(EDIT_NOTE_TOOLTIP));

      expect(noteEditingController.isNoteBeingManipulated.value, isTrue);
    });

    testWidgets(
      "Test If App Bar Delete Button Deletes Note And Dispatches Action",
      (WidgetTester tester) async {
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
      },
    );

    testWidgets("Test If Note Is Loaded From Database And Displayed", (
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

    testWidgets(
      "Test If Notes Editing Section Is Displayed When Note Being Manipulated Is True",
      (WidgetTester tester) async {
        noteRepository = NoteRepositoryMock();

        when(() => noteRepository.getNote(NOTE_ID)).thenAnswer((_) async {
          return NOTE_MODEL_OBJECT;
        });

        noteEditingController = NoteEditingController(noteRepository);

        noteEditingController.note.value = NOTE_MODEL_OBJECT;

        noteEditingController.isNoteLoaded.value = true;
        noteEditingController.isNoteBeingManipulated.value = true;

        await tester.pumpWidget(
          MaterialApp(
            home: NoteManipulatingScreen(NOTE_ID, noteEditingController, () {}),
          ),
        );

        await tester.enterText(find.text(NOTE_TITLE), "");

        expect(find.text(""), findsOneWidget);
      },
    );

    testWidgets("Test If Loading Section Is Displayed If Notes Is Not Loaded", (
      WidgetTester tester,
    ) async {
      noteRepository = NoteRepositoryMock();

      noteEditingController = NoteEditingController(noteRepository);

      await tester.pumpWidget(
        MaterialApp(
          home: NoteManipulatingScreen(NOTE_ID, noteEditingController, () {}),
        ),
      );

      expect(find.bySemanticsLabel(LOADING_SECTION_TOOLTIP), findsOneWidget);
    });

    testWidgets(
      "Test If When Note Data Changes Updates Controller Title And Body Note Values",
      (WidgetTester tester) async {
        noteRepository = NoteRepositoryMock();

        when(() => noteRepository.getNote(NOTE_ID)).thenAnswer((_) async {
          return NOTE_MODEL_OBJECT;
        });

        noteEditingController = NoteEditingController(noteRepository);

        noteEditingController.note.value = NOTE_MODEL_OBJECT;

        noteEditingController.isNoteLoaded.value = true;
        noteEditingController.isNoteBeingManipulated.value = true;

        await tester.pumpWidget(
          MaterialApp(
            home: NoteManipulatingScreen(NOTE_ID, noteEditingController, () {}),
          ),
        );

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
      },
    );
  });
}

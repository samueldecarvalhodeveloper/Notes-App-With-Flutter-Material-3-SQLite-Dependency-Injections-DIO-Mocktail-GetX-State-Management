import "dart:io";
import "package:flutter_test/flutter_test.dart";
import "package:dio/dio.dart";
import "package:mocktail/mocktail.dart";
import "package:notes_app/constants/application_constants.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/data_access_objects/note_data_access_object.dart";
import "package:notes_app/data_gateways/note_gateway.dart";
import "package:notes_app/infrastructure/entities/note_entity.dart";
import "package:notes_app/repositories/note_repository.dart";
import "package:notes_app/controllers/note_editing_controller.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "../../mocks/http_client_implementation_mock.dart";

void main() {
  group("Test Class NoteEditingController", () {
    late Database databaseDriver;
    late HttpClientImplementationMock httpClientImplementation;
    late NoteDataAccessObject noteDataAccessObject;
    late NoteGateway noteGateway;
    late NoteRepository noteRepository;
    late NoteEditingController noteEditingController;

    setUp(() async {
      sqfliteFfiInit();

      databaseFactory = databaseFactoryFfi;
      databaseDriver = await databaseFactory.openDatabase(inMemoryDatabasePath);

      await databaseDriver.execute(NOTE_DATABASE_CREATION_QUERY);

      noteDataAccessObject = NoteDataAccessObject(databaseDriver);

      httpClientImplementation = HttpClientImplementationMock();
    });

    tearDown(() async {
      await databaseDriver.close();
    });

    test(
      "Test Method \"loadNote\" Loads Note From Database And Set The State",
      () async {
        when(() => httpClientImplementation.get("")).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ""),
            statusCode: HttpStatus.ok,
          ),
        );

        await noteDataAccessObject.createNote(NOTE_ENTITY_OBJECT);

        noteGateway = NoteGateway(httpClientImplementation);

        noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

        noteEditingController = NoteEditingController(noteRepository);

        await noteEditingController.loadNote(NOTE_ID);

        expect(noteEditingController.note.value!.id, NOTE_ID);
        expect(noteEditingController.note.value!.title, NOTE_TITLE);
        expect(noteEditingController.note.value!.body, NOTE_BODY);
        expect(noteEditingController.note.value!.createdAt, NOTE_CREATED_AT);
        expect(noteEditingController.note.value!.updatedAt, NOTE_UPDATED_AT);
        expect(noteEditingController.note.value!.userId, USER_ID);
      },
    );

    test(
      "Test Method \"concludeNote\" Updates Note On Database And On Service With Updated Note Title And Body",
      () async {
        when(
          () => httpClientImplementation.patch(
            "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
            data: NOTE_DATA_TRANSFER_OBJECT_OBJECT.getMap(),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: NOTE_ENTITY_OBJECT.getMap(),
            requestOptions: RequestOptions(
              path: "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
            ),
            statusCode: HttpStatus.ok,
          ),
        );

        await noteDataAccessObject.createNote(
          NOTE_ENTITY_WITH_WRONG_DATA_OBJECT,
        );

        noteGateway = NoteGateway(httpClientImplementation);

        noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

        noteEditingController = NoteEditingController(noteRepository);

        noteEditingController.note.value =
            NOTE_ENTITY_WITH_WRONG_DATA_OBJECT.getModel();

        noteEditingController.setNoteTitle(NOTE_TITLE);
        noteEditingController.setNoteBody(NOTE_BODY);

        await noteEditingController.concludeNote();

        NoteEntity noteFromDatabase = await noteDataAccessObject.getNote(
          NOTE_ID,
        );

        expect(noteEditingController.note.value!.id, NOTE_ID);
        expect(noteEditingController.note.value!.title, NOTE_TITLE);
        expect(noteEditingController.note.value!.body, NOTE_BODY);
        expect(noteEditingController.note.value!.createdAt, NOTE_CREATED_AT);
        expect(noteEditingController.note.value!.updatedAt, NOTE_UPDATED_AT);
        expect(noteEditingController.note.value!.userId, USER_ID);

        expect(noteFromDatabase.id, NOTE_ID);
        expect(noteFromDatabase.title, NOTE_TITLE);
        expect(noteFromDatabase.body, NOTE_BODY);
        expect(noteFromDatabase.createdAt, NOTE_CREATED_AT);
        expect(noteFromDatabase.updatedAt, NOTE_UPDATED_AT);
        expect(noteFromDatabase.userId, USER_ID);

        expect(noteEditingController.isNoteBeingManipulated.value, isFalse);
      },
    );

    test(
      "Test Method \"concludeNote\" Makes Note Manipulation Unable If Updating Fail",
      () async {
        when(
          () => httpClientImplementation.patch(
            "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
            data: NOTE_DATA_TRANSFER_OBJECT_OBJECT.getMap(),
          ),
        ).thenAnswer((_) async {
          throw DioException(
            requestOptions: RequestOptions(
              path: "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/",
            ),
            error: HttpStatus.serviceUnavailable.toString(),
          );
        });

        noteGateway = NoteGateway(httpClientImplementation);

        noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

        noteEditingController = NoteEditingController(noteRepository);

        await noteEditingController.concludeNote();

        expect(noteEditingController.isNoteManipulationAble.value, isFalse);
        expect(noteEditingController.isNoteBeingManipulated.value, isFalse);
      },
    );

    test(
      "Test Method \"manipulateNote\" Makes \"isNoteBeingManipulated\" State True",
      () {
        when(() => httpClientImplementation.get("")).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ""),
            statusCode: HttpStatus.ok,
          ),
        );

        noteGateway = NoteGateway(httpClientImplementation);

        noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

        noteEditingController = NoteEditingController(noteRepository);

        noteEditingController.manipulateNote();

        expect(noteEditingController.isNoteBeingManipulated.value, isTrue);
      },
    );

    test(
      "Test Method \"deleteNote\" Deletes Note On Database And On Service And Execute On Note Deleted Action",
      () async {
        bool isNoteDeleted = false;

        when(
          () => httpClientImplementation.delete(
            "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
          ),
        ).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(
              path: "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
            ),
            statusCode: HttpStatus.noContent,
          ),
        );

        await noteDataAccessObject.createNote(NOTE_ENTITY_OBJECT);

        noteGateway = NoteGateway(httpClientImplementation);

        noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

        noteEditingController = NoteEditingController(noteRepository);

        noteEditingController.note.value = NOTE_MODEL_OBJECT;

        await noteEditingController.deleteNote(() => isNoteDeleted = true);

        List<NoteEntity> listOfNotesFromDatabase =
            await noteDataAccessObject.getNotes();

        expect(listOfNotesFromDatabase.length, 0);

        expect(isNoteDeleted, isTrue);
      },
    );

    test(
      "Test Method \"deleteNote\" Makes Note Manipulation Unable If Deleting Fail",
      () async {
        when(
          () => httpClientImplementation.delete(
            "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
          ),
        ).thenAnswer((_) async {
          throw DioException(
            requestOptions: RequestOptions(
              path: "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
            ),
            error: HttpStatus.serviceUnavailable.toString(),
          );
        });

        noteGateway = NoteGateway(httpClientImplementation);

        noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

        noteEditingController = NoteEditingController(noteRepository);

        noteEditingController.note.value = NOTE_MODEL_OBJECT;

        await noteEditingController.deleteNote(() => {});

        expect(noteEditingController.isNoteManipulationAble.value, isFalse);
        expect(noteEditingController.isNoteBeingManipulated.value, isFalse);
      },
    );
  });
}

import "dart:io";
import "package:dio/dio.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:notes_app/constants/application_constants.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/data_access_objects/note_data_access_object.dart";
import "package:notes_app/data_gateways/note_gateway.dart";
import "package:notes_app/infrastructure/entities/note_entity.dart";
import "package:notes_app/infrastructure/models/note.dart";
import "package:notes_app/repositories/note_repository.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "../mocks/http_client_implementation_mock.dart";

void main() {
  group("Test Component Note", () {
    late Database databaseDriver;
    late HttpClientImplementationMock httpClientImplementation;
    late NoteDataAccessObject noteDataAccessObject;
    late NoteGateway noteGateway;
    late NoteRepository noteRepository;

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

    test("Test Fetching Notes From Service And Storing On Database", () async {
      when(() => httpClientImplementation.get(any())).thenAnswer(
        (_) async => Response(
          data: [NOTE_ENTITY_OBJECT.getMap()],
          statusCode: HttpStatus.ok,
          requestOptions: RequestOptions(
            path: "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/",
          ),
        ),
      );

      noteGateway = NoteGateway(httpClientImplementation);

      noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

      await noteRepository.fetchNotesFromService(USER_ID);

      List<NoteEntity> listOfNotesFromDatabase =
          await noteDataAccessObject.getNotes();

      expect(listOfNotesFromDatabase.length, 1);
      expect(listOfNotesFromDatabase[0].id, NOTE_ID);
      expect(listOfNotesFromDatabase[0].title, NOTE_TITLE);
      expect(listOfNotesFromDatabase[0].body, NOTE_BODY);
      expect(listOfNotesFromDatabase[0].createdAt, NOTE_CREATED_AT);
      expect(listOfNotesFromDatabase[0].updatedAt, NOTE_UPDATED_AT);
      expect(listOfNotesFromDatabase[0].userId, USER_ID);
    });

    test("Test Getting Notes", () async {
      noteGateway = NoteGateway(httpClientImplementation);

      noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

      List<Note> listOfNotesFromDatabase = await noteRepository.getNotes();

      expect(listOfNotesFromDatabase.length, 0);
    });

    test("Test Getting Note", () async {
      await noteDataAccessObject.createNote(NOTE_ENTITY_OBJECT);

      noteGateway = NoteGateway(httpClientImplementation);

      noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

      Note noteFromDatabase = await noteRepository.getNote(NOTE_ID);

      expect(noteFromDatabase.id, NOTE_ID);
      expect(noteFromDatabase.title, NOTE_TITLE);
      expect(noteFromDatabase.body, NOTE_BODY);
      expect(noteFromDatabase.createdAt, NOTE_CREATED_AT);
      expect(noteFromDatabase.updatedAt, NOTE_UPDATED_AT);
      expect(noteFromDatabase.userId, USER_ID);
    });

    test("Test Creating Note", () async {
      when(
        () => httpClientImplementation.post(
          "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/",
          data: NOTE_DATA_TRANSFER_OBJECT_OBJECT.getMap(),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: NOTE_ENTITY_OBJECT.getMap(),
          statusCode: HttpStatus.created,
          requestOptions: RequestOptions(
            path: "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/",
          ),
        ),
      );

      noteGateway = NoteGateway(httpClientImplementation);

      noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

      Note noteFromService = await noteRepository.getCreatedNote(
        NOTE_TITLE,
        NOTE_BODY,
        USER_ID,
      );

      expect(noteFromService.id, NOTE_ID);
      expect(noteFromService.title, NOTE_TITLE);
      expect(noteFromService.body, NOTE_BODY);
      expect(noteFromService.createdAt, NOTE_CREATED_AT);
      expect(noteFromService.updatedAt, NOTE_UPDATED_AT);
      expect(noteFromService.userId, USER_ID);
    });

    test("Test Updating Note", () async {
      when(
        () => httpClientImplementation.patch(
          "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
          data: NOTE_DATA_TRANSFER_OBJECT_OBJECT.getMap(),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: NOTE_ENTITY_OBJECT.getMap(),
          statusCode: HttpStatus.ok,
          requestOptions: RequestOptions(
            path: "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
          ),
        ),
      );

      await noteDataAccessObject.createNote(NOTE_ENTITY_WITH_WRONG_DATA_OBJECT);

      noteGateway = NoteGateway(httpClientImplementation);

      noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

      Note noteFromService = await noteRepository.getUpdatedNote(
        NOTE_ID,
        NOTE_TITLE,
        NOTE_BODY,
        USER_ID,
      );

      NoteEntity noteFromDatabase = await noteDataAccessObject.getNote(NOTE_ID);

      expect(noteFromService.id, NOTE_ID);
      expect(noteFromService.title, NOTE_TITLE);
      expect(noteFromService.body, NOTE_BODY);
      expect(noteFromService.createdAt, NOTE_CREATED_AT);
      expect(noteFromService.updatedAt, NOTE_UPDATED_AT);
      expect(noteFromService.userId, USER_ID);

      expect(noteFromDatabase.id, NOTE_ID);
      expect(noteFromDatabase.title, NOTE_TITLE);
      expect(noteFromDatabase.body, NOTE_BODY);
      expect(noteFromDatabase.createdAt, NOTE_CREATED_AT);
      expect(noteFromDatabase.updatedAt, NOTE_UPDATED_AT);
      expect(noteFromDatabase.userId, USER_ID);
    });

    test("Test Deleting Note", () async {
      when(
        () => httpClientImplementation.delete(
          "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
        ),
      ).thenAnswer(
        (_) async => Response(
          data: NOTE_ENTITY_OBJECT.getMap(),
          statusCode: HttpStatus.noContent,
          requestOptions: RequestOptions(
            path: "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
          ),
        ),
      );

      await noteDataAccessObject.createNote(NOTE_ENTITY_OBJECT);

      noteGateway = NoteGateway(httpClientImplementation);

      noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

      await noteRepository.deleteNote(NOTE_ID, USER_ID);

      List<NoteEntity> listOfNotesFromDatabase =
          await noteDataAccessObject.getNotes();

      expect(listOfNotesFromDatabase.length, 0);
    });
  });
}

import "dart:io";
import "package:dio/dio.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:notes_app/constants/application_constants.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/data_access_objects/note_data_access_object.dart";
import "package:notes_app/data_gateways/note_gateway.dart";
import "package:notes_app/repositories/note_repository.dart";
import "package:notes_app/controllers/notes_listing_controller.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "../../mocks/http_client_implementation_mock.dart";

void main() {
  group("Test Class NotesListingController", () {
    late Database databaseDriver;
    late HttpClientImplementationMock httpClientImplementation;
    late NoteDataAccessObject noteDataAccessObject;
    late NoteGateway noteGateway;
    late NoteRepository noteRepository;
    late NotesListingController notesListingController;

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

      resetMocktailState();
    });

    test(
      "Test Method \"loadNotes\" Fetches Notes From Service And Set List Of Notes State",
      () async {
        when(
          () => httpClientImplementation.get(
            "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/",
          ),
        ).thenAnswer(
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

        notesListingController = NotesListingController(noteRepository);

        await notesListingController.loadNotes(USER_ID);

        expect(notesListingController.listOfNotes.length, 1);
        expect(notesListingController.isListOfNotesLoaded, isTrue);
      },
    );

    test(
      "Test Method \"createNote\" Creates Note On Service And On Database And Dispatches Action On Note Created",
      () async {
        int? createdNoteOnServiceId = null;

        when(
          () => httpClientImplementation.post(
            "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/",
            data: NOTE_DATA_TRANSFER_OBJECT_WITH_WRONG_DATA_OBJECT.getMap(),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: NOTE_ENTITY_WITH_WRONG_DATA_OBJECT.getMap(),
            statusCode: HttpStatus.created,
            requestOptions: RequestOptions(
              path: "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/",
            ),
          ),
        );

        noteGateway = NoteGateway(httpClientImplementation);

        noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

        notesListingController = NotesListingController(noteRepository);

        await notesListingController.createNote(USER_ID, (noteId) {
          createdNoteOnServiceId = noteId;
        });

        expect(createdNoteOnServiceId, NOTE_ID);
      },
    );

    test(
      "Test Method \"createNote\" Makes Note Creation Unable If Creation Fail",
      () async {
        when(
          () => httpClientImplementation.post(
            "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/",
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

        notesListingController = NotesListingController(noteRepository);

        await notesListingController.createNote(USER_ID, (createdNoteId) => {});

        expect(notesListingController.isNoteCreationCurrentlyAble, isFalse);
      },
    );
  });
}

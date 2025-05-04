import "dart:io";
import "package:dio/dio.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:notes_app/constants/application_constants.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/data_gateways/note_gateway.dart";
import "package:notes_app/infrastructure/models/note.dart";
import "../../mocks/http_client_implementation_mock.dart";

void main() {
  group("Test Class NoteGateway", () {
    late HttpClientImplementationMock httpClientImplementation;
    late NoteGateway noteGateway;

    setUp(() {
      httpClientImplementation = HttpClientImplementationMock();

      noteGateway = NoteGateway(httpClientImplementation);
    });

    test("Test Method \"getNotes\" Returns Notes From Service", () async {
      Response requestResponse = Response(
        data: [NOTE_ENTITY_OBJECT.getMap()],
        statusCode: HttpStatus.ok,
        requestOptions: RequestOptions(
          path: "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/",
        ),
      );

      when(
        () => httpClientImplementation.get(
          "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/",
        ),
      ).thenAnswer((_) async => requestResponse);

      List<Note> listOfNotesFromService = await noteGateway.getNotes(USER_ID);

      expect(listOfNotesFromService.length, 1);
      expect(listOfNotesFromService[0].id, NOTE_ID);
      expect(listOfNotesFromService[0].title, NOTE_TITLE);
      expect(listOfNotesFromService[0].body, NOTE_BODY);
      expect(listOfNotesFromService[0].createdAt, NOTE_CREATED_AT);
      expect(listOfNotesFromService[0].updatedAt, NOTE_UPDATED_AT);
      expect(listOfNotesFromService[0].userId, USER_ID);
    });

    test(
      "Test Method \"getCreatedNoteOnService\" Returns Created Note On Service",
      () async {
        Response requestResponse = Response(
          data: NOTE_ENTITY_OBJECT.getMap(),
          statusCode: HttpStatus.created,
          requestOptions: RequestOptions(
            path: "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/",
          ),
        );

        when(
          () => httpClientImplementation.post(
            "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/",
            data: NOTE_DATA_TRANSFER_OBJECT_OBJECT.getMap(),
          ),
        ).thenAnswer((_) async => requestResponse);

        Note createdNoteFromService = await noteGateway.getCreatedNoteOnService(
          USER_ID,
          NOTE_DATA_TRANSFER_OBJECT_OBJECT,
        );

        expect(createdNoteFromService.id, NOTE_ID);
        expect(createdNoteFromService.title, NOTE_TITLE);
        expect(createdNoteFromService.body, NOTE_BODY);
        expect(createdNoteFromService.createdAt, NOTE_CREATED_AT);
        expect(createdNoteFromService.updatedAt, NOTE_UPDATED_AT);
        expect(createdNoteFromService.userId, USER_ID);
      },
    );

    test(
      "Test Method \"getUpdatedNoteOnService\" Returns Updated Note On Service",
      () async {
        Response requestResponse = Response(
          data: NOTE_ENTITY_OBJECT.getMap(),
          statusCode: HttpStatus.ok,
          requestOptions: RequestOptions(
            path: "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
          ),
        );

        when(
          () => httpClientImplementation.patch(
            "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
            data: NOTE_DATA_TRANSFER_OBJECT_OBJECT.getMap(),
          ),
        ).thenAnswer((_) async => requestResponse);

        Note updatedNoteFromService = await noteGateway.getUpdatedNoteOnService(
          USER_ID,
          NOTE_ID,
          NOTE_DATA_TRANSFER_OBJECT_OBJECT,
        );

        expect(updatedNoteFromService.id, NOTE_ID);
        expect(updatedNoteFromService.title, NOTE_TITLE);
        expect(updatedNoteFromService.body, NOTE_BODY);
        expect(updatedNoteFromService.createdAt, NOTE_CREATED_AT);
        expect(updatedNoteFromService.updatedAt, NOTE_UPDATED_AT);
        expect(updatedNoteFromService.userId, USER_ID);
      },
    );

    test("Test Method \"deleteNote\" Deletes Note On Service", () async {
      Response requestResponse = Response(
        data: "",
        statusCode: HttpStatus.noContent,
        requestOptions: RequestOptions(
          path: "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
        ),
      );

      when(
        () => httpClientImplementation.delete(
          "$SERVICE_URL$NOTE_BASE_ROUTE/$USER_ID/$NOTE_ID/",
        ),
      ).thenAnswer((_) async => requestResponse);

      await noteGateway.deleteNote(NOTE_ID, USER_ID);
    });
  });
}

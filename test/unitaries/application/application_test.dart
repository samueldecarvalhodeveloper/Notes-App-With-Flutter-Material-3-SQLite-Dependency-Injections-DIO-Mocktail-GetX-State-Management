import "dart:io";
import "package:dio/dio.dart";
import "package:flutter_test/flutter_test.dart";
import "package:get/get.dart" hide Response;
import "package:mocktail/mocktail.dart";
import "package:notes_app/application/application.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/constants/user_interface_constants.dart";
import "package:notes_app/data_access_objects/note_data_access_object.dart";
import "package:notes_app/data_access_objects/user_data_access_object.dart";
import "package:notes_app/data_gateways/note_gateway.dart";
import "package:notes_app/data_gateways/user_gateway.dart";
import "package:notes_app/repositories/note_repository.dart";
import "package:notes_app/repositories/user_repository.dart";
import "package:notes_app/controllers/note_editing_controller.dart";
import "package:notes_app/controllers/notes_listing_controller.dart";
import "package:notes_app/controllers/user_controller.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "../../mocks/http_client_implementation_mock.dart";

void main() {
  group("Test Class Application", () {
    late Database databaseDriver;
    late HttpClientImplementationMock httpClientImplementation;
    late UserDataAccessObject userDataAccessObject;
    late NoteDataAccessObject noteDataAccessObject;
    late UserGateway userGateway;
    late NoteGateway noteGateway;
    late UserRepository userRepository;
    late NoteRepository noteRepository;

    setUp(() async {
      sqfliteFfiInit();

      databaseFactory = databaseFactoryFfi;
      databaseDriver = await databaseFactory.openDatabase(inMemoryDatabasePath);

      await databaseDriver.execute(USER_DATABASE_CREATION_QUERY);
      await databaseDriver.execute(NOTE_DATABASE_CREATION_QUERY);

      userDataAccessObject = UserDataAccessObject(databaseDriver);
      noteDataAccessObject = NoteDataAccessObject(databaseDriver);

      httpClientImplementation = HttpClientImplementationMock();
    });

    tearDown(() async {
      await databaseDriver.close();
    });

    testWidgets("Test If Routes Are Set", (WidgetTester tester) async {
      when(() => httpClientImplementation.get(any())).thenAnswer(
        (_) async => Response(
          data: "",
          statusCode: HttpStatus.ok,
          requestOptions: RequestOptions(path: ""),
        ),
      );

      userGateway = UserGateway(httpClientImplementation);
      noteGateway = NoteGateway(httpClientImplementation);

      userRepository = UserRepository(userGateway, userDataAccessObject);
      noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

      Get.put<UserController>(UserController(userRepository), permanent: true);
      Get.put<NotesListingController>(NotesListingController(noteRepository));
      Get.put<NoteEditingController>(NoteEditingController(noteRepository));

      await tester.pumpWidget(Application());

      expect(find.text(CREATE_USER_BUTTON_TEXT), findsOneWidget);
    });
  });
}

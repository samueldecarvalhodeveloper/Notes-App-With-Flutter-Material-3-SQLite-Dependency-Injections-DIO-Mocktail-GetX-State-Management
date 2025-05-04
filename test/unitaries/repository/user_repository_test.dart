import "dart:io";
import "package:dio/dio.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:notes_app/constants/application_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/data_access_objects/user_data_access_object.dart";
import "package:notes_app/data_gateways/user_gateway.dart";
import "package:notes_app/infrastructure/models/user.dart";
import "package:notes_app/repositories/user_repository.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "../../mocks/http_client_implementation_mock.dart";

void main() {
  group("Test Class UserRepository", () {
    late Database databaseDriver;
    late HttpClientImplementationMock httpClientImplementation;
    late UserDataAccessObject userDataAccessObject;
    late UserGateway userGateway;
    late UserRepository userRepository;

    setUp(() async {
      sqfliteFfiInit();

      databaseFactory = databaseFactoryFfi;
      databaseDriver = await databaseFactory.openDatabase(inMemoryDatabasePath);

      await databaseDriver.execute(USER_DATABASE_CREATION_QUERY);

      userDataAccessObject = UserDataAccessObject(databaseDriver);

      httpClientImplementation = HttpClientImplementationMock();
    });

    tearDown(() async {
      await databaseDriver.close();
    });

    test("Test Method \"getUser\" Returns User Stored on Database", () async {
      when(() => httpClientImplementation.get(any())).thenAnswer(
        (_) async => Response(
          data: "",
          statusCode: HttpStatus.ok,
          requestOptions: RequestOptions(path: ""),
        ),
      );

      await userDataAccessObject.createUser(USER_ENTITY_OBJECT);

      userGateway = UserGateway(httpClientImplementation);

      userRepository = UserRepository(userGateway, userDataAccessObject);

      User userFromDatabase = await userRepository.getUser();

      expect(userFromDatabase.id, USER_ID);
      expect(userFromDatabase.username, USER_USERNAME);
    });

    test(
      "Test Method \"getCreatedUser\" Creates User On Database And On Service",
      () async {
        final requestResponse = Response(
          data: USER_ENTITY_OBJECT.getMap(),
          statusCode: HttpStatus.created,
          requestOptions: RequestOptions(path: "$SERVICE_URL$USER_BASE_ROUTE/"),
        );

        when(
          () => httpClientImplementation.post(
            "$SERVICE_URL$USER_BASE_ROUTE/",
            data: USER_DATA_TRANSFER_OBJECT_OBJECT.getMap(),
          ),
        ).thenAnswer((_) async => requestResponse);

        userGateway = UserGateway(httpClientImplementation);

        userRepository = UserRepository(userGateway, userDataAccessObject);

        User createUser = await userRepository.getCreatedUser(USER_USERNAME);

        expect(createUser.id, USER_ID);
        expect(createUser.username, USER_USERNAME);
      },
    );
  });
}

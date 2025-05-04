import "dart:io";
import "package:flutter_test/flutter_test.dart";
import "package:dio/dio.dart";
import "package:mocktail/mocktail.dart";
import "package:notes_app/constants/application_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/data_access_objects/user_data_access_object.dart";
import "package:notes_app/data_gateways/user_gateway.dart";
import "package:notes_app/repositories/user_repository.dart";
import "package:notes_app/controllers/user_controller.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "../../mocks/http_client_implementation_mock.dart";

void main() {
  group("Test Class UserController", () {
    late Database databaseDriver;
    late Dio httpClientImplementation;
    late UserDataAccessObject userDataAccessObject;
    late UserGateway userGateway;
    late UserRepository userRepository;
    late UserController userController;

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

    test(
      "Test Method \"verifyIfUserExists\" Sets User State And Dispatches On User Created If User Exists",
      () async {
        bool isUserCreated = false;

        await userDataAccessObject.createUser(USER_ENTITY_OBJECT);

        userGateway = UserGateway(httpClientImplementation);

        userRepository = UserRepository(userGateway, userDataAccessObject);

        userController = UserController(userRepository);

        await userController.verifyIfUserExists(() => isUserCreated = true);

        expect(isUserCreated, isTrue);
      },
    );

    test(
      "Test Method \"createUser\" Makes \"isUserUsernameInvalid\" To True If User Username Is Empty",
      () async {
        userGateway = UserGateway(httpClientImplementation);

        userRepository = UserRepository(userGateway, userDataAccessObject);

        userController = UserController(userRepository);

        await userController.createUser("", () => {});

        expect(userController.isUserUsernameInvalid, isTrue);
      },
    );

    test(
      "Test Method \"createUser\" Makes \"isInternetErrorRisen\" To True If There Is No Internet Connection",
      () async {
        when(
          () => httpClientImplementation.post(
            "$SERVICE_URL$USER_BASE_ROUTE/",
            data: USER_DATA_TRANSFER_OBJECT_OBJECT.getMap(),
          ),
        ).thenAnswer((_) async {
          throw DioException(
            requestOptions: RequestOptions(
              path: "$SERVICE_URL$USER_BASE_ROUTE/",
            ),
            error: HttpStatus.serviceUnavailable.toString(),
          );
        });

        userGateway = UserGateway(httpClientImplementation);

        userRepository = UserRepository(userGateway, userDataAccessObject);

        userController = UserController(userRepository);

        await userController.createUser(USER_USERNAME, () {});

        expect(userController.isInternetErrorRisen, isTrue);
      },
    );

    test(
      "Test Method \"createUser\" Makes \"isUserUsernameInvalid\" To False And Creates User On Database And On Service And Dispatches On User Created If User Exists",
      () async {
        bool isUserCreated = false;

        when(
          () => httpClientImplementation.post(
            "$SERVICE_URL$USER_BASE_ROUTE/",
            data: USER_DATA_TRANSFER_OBJECT_OBJECT.getMap(),
          ),
        ).thenAnswer(
          (_) async => Response(
            data: USER_ENTITY_OBJECT.getMap(),
            statusCode: HttpStatus.created,
            requestOptions: RequestOptions(
              path: "$SERVICE_URL$USER_BASE_ROUTE/",
            ),
          ),
        );

        userGateway = UserGateway(httpClientImplementation);

        userRepository = UserRepository(userGateway, userDataAccessObject);

        userController = UserController(userRepository);

        await userController.createUser(
          USER_USERNAME,
          () => isUserCreated = true,
        );

        expect(userController.user.value!.id, USER_ID);
        expect(userController.user.value!.username, USER_USERNAME);

        expect(userController.isUserUsernameInvalid, isFalse);

        expect(isUserCreated, isTrue);
      },
    );
  });
}

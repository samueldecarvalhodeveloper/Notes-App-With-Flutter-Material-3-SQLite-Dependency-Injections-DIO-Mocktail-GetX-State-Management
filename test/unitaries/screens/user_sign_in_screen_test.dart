import "dart:io";
import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:dio/dio.dart";
import "package:mocktail/mocktail.dart";
import "package:notes_app/constants/application_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/constants/user_interface_constants.dart";
import "package:notes_app/data_access_objects/user_data_access_object.dart";
import "package:notes_app/data_gateways/user_gateway.dart";
import "package:notes_app/infrastructure/models/user.dart";
import "package:notes_app/repositories/user_repository.dart";
import "package:notes_app/screens/user_sign_in_screen.dart";
import "package:notes_app/controllers/user_controller.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "../../mocks/http_client_implementation_mock.dart";
import "../../mocks/user_repository_mock.dart";

void main() {
  group("Test Screen UserSignInScreen", () {
    late Database databaseDriver;
    late HttpClientImplementationMock httpClientImplementation;
    late UserDataAccessObject userDataAccessObject;
    late UserGateway userGateway;
    late UserRepository userRepository;
    late UserController userController;

    setUp(() async {
      sqfliteFfiInit();

      databaseFactory = databaseFactoryFfi;
      databaseDriver = await databaseFactory.openDatabase(inMemoryDatabasePath);

      userDataAccessObject = UserDataAccessObject(databaseDriver);

      httpClientImplementation = HttpClientImplementationMock();
    });

    tearDown(() async {
      await databaseDriver.close();
    });

    testWidgets(
      "Test If Not Valid Username Error Message Is Displayed When Not Valid User Username Is Submitted",
      (WidgetTester tester) async {
        when(() => httpClientImplementation.post("", data: "")).thenAnswer(
          (_) async => Response(
            requestOptions: RequestOptions(path: ""),
            statusCode: HttpStatus.ok,
          ),
        );

        userGateway = UserGateway(httpClientImplementation);

        userRepository = UserRepository(userGateway, userDataAccessObject);

        userController = UserController(userRepository);

        await tester.pumpWidget(
          MaterialApp(home: UserSignInScreen(userController, () {})),
        );

        await tester.tap(find.text(CREATE_USER_BUTTON_TEXT));

        await tester.pump();

        expect(find.text(NOT_VALID_USERNAME_ERROR_MESSAGE), findsOneWidget);
      },
    );

    testWidgets(
      "Test If Not Available Internet Error Message Is Displayed When Internet Is Not Available On User Creation Submission",
      (WidgetTester tester) async {
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

        await tester.pumpWidget(
          MaterialApp(home: UserSignInScreen(userController, () {})),
        );

        await tester.enterText(
          find.byType(TextField),
          TEXT_INPUT_PLACEHOLDER_TEXT,
        );

        await tester.tap(find.text(CREATE_USER_BUTTON_TEXT));

        await tester.pump();

        expect(find.text(NOT_AVAILABLE_INTERNET_ERROR_MESSAGE), findsOneWidget);
      },
    );

    testWidgets(
      "Test if User Interface Executes Callback On User Existing When User Is Created",
      (WidgetTester tester) async {
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

        expect(isUserCreated, isTrue);
      },
    );

    testWidgets(
      "Test if User Interface Executes Callback On User Existing When User Is Existing",
      (WidgetTester tester) async {
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

        expect(isUserCreated, isTrue);
      },
    );
  });
}

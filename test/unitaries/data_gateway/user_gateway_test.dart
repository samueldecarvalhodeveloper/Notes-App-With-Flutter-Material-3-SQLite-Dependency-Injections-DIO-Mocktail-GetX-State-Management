import "dart:io";
import "package:dio/dio.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:notes_app/constants/application_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/data_gateways/user_gateway.dart";
import "package:notes_app/infrastructure/models/user.dart";
import "../../mocks/http_client_implementation_mock.dart";

void main() {
  group("Test Class UserGateway", () {
    late HttpClientImplementationMock httpClientImplementation;
    late UserGateway userGateway;

    setUp(() {
      httpClientImplementation = HttpClientImplementationMock();

      userGateway = UserGateway(httpClientImplementation);
    });

    test(
      "Test Method \"getCreatedUserOnService\" Returns User Created On Service",
      () async {
        Response requestResponse = Response(
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

        User createdUserOnService = await userGateway.getCreatedUserOnService(
          USER_DATA_TRANSFER_OBJECT_OBJECT,
        );

        expect(createdUserOnService.id, USER_ID);
        expect(createdUserOnService.username, USER_USERNAME);
      },
    );
  });
}

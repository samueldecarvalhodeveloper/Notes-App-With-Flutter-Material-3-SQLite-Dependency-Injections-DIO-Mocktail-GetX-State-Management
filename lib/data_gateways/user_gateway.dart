import "package:dio/dio.dart";
import "package:notes_app/constants/application_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/infrastructure/data_transfer_objects/user_data_transfer_object.dart";
import "package:notes_app/infrastructure/models/user.dart";

class UserGateway {
  final Dio _httpClientImplementation;

  UserGateway(this._httpClientImplementation);

  Future<User> getCreatedUserOnService(UserDataTransferObject user) async {
    Response requestResponse = await _httpClientImplementation.post(
      "$SERVICE_URL$USER_BASE_ROUTE/",
      data: user.getMap(),
    );

    return User.getModelFromMap(requestResponse.data);
  }
}

import "package:notes_app/data_access_objects/user_data_access_object.dart";
import "package:notes_app/data_gateways/user_gateway.dart";
import "package:notes_app/infrastructure/data_transfer_objects/user_data_transfer_object.dart";
import "package:notes_app/infrastructure/models/user.dart";

class UserRepository {
  final UserGateway _userGateway;
  final UserDataAccessObject _userDataAccessObject;

  UserRepository(this._userGateway, this._userDataAccessObject);

  Future<User> getUser() async {
    return (await _userDataAccessObject.getUsers()).first.getModel();
  }

  Future<User> getCreatedUser(String username) async {
    UserDataTransferObject userDataTransferObject = UserDataTransferObject(
      username,
    );

    User createdUserOnService = await _userGateway.getCreatedUserOnService(
      userDataTransferObject,
    );

    await _userDataAccessObject.createUser(createdUserOnService.getEntity());

    return createdUserOnService;
  }
}

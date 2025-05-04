import "package:notes_app/constants/user_constants.dart";

class UserDataTransferObject {
  String username;

  UserDataTransferObject(this.username);

  Map<String, dynamic> getMap() {
    return {USER_USERNAME_RESPONSE_FIELD: username};
  }
}

import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/infrastructure/models/user.dart";

class UserEntity {
  int id;
  String username;

  UserEntity(this.id, this.username);

  static UserEntity getEntityFromMap(Map<String, dynamic> map) {
    return UserEntity(map[USER_ID_COLUMN], map[USER_USERNAME_COLUMN]);
  }

  Map<String, dynamic> getMap() {
    return {USER_ID_COLUMN: id, USER_USERNAME_COLUMN: username};
  }

  User getModel() {
    return User(id, username);
  }
}

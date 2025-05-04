import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/infrastructure/entities/user_entity.dart";

class User {
  int id;
  String username;

  User(this.id, this.username);

  static User getModelFromMap(Map<String, dynamic> map) {
    return User(map[USER_ID_COLUMN], map[USER_USERNAME_COLUMN]);
  }

  UserEntity getEntity() {
    return UserEntity(id, username);
  }
}

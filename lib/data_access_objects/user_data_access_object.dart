import "package:sqflite/sqflite.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/infrastructure/entities/user_entity.dart";

class UserDataAccessObject {
  final Database _databaseDriver;

  UserDataAccessObject(this._databaseDriver);

  Future<List<UserEntity>> getUsers() async {
    List<Map<String, dynamic>> listOfUsersFromDatabase = await _databaseDriver
        .query(USER_DATABASE_TABLE_NAME);

    return listOfUsersFromDatabase
        .map((map) => UserEntity.getEntityFromMap(map))
        .toList();
  }

  Future<void> createUser(UserEntity user) async {
    await _databaseDriver.insert(
      USER_DATABASE_TABLE_NAME,
      user.getMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
}

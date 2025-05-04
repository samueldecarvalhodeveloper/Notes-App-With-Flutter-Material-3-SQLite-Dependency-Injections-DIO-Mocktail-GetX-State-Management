import "package:flutter_test/flutter_test.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/data_access_objects/user_data_access_object.dart";
import "package:notes_app/infrastructure/entities/user_entity.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

void main() {
  group("Test Class UserDataAccessObject", () {
    late Database databaseDriver;
    late UserDataAccessObject userDataAccessObject;

    setUp(() async {
      sqfliteFfiInit();

      databaseFactory = databaseFactoryFfi;
      databaseDriver = await databaseFactory.openDatabase(inMemoryDatabasePath);

      await databaseDriver.execute(USER_DATABASE_CREATION_QUERY);

      userDataAccessObject = UserDataAccessObject(databaseDriver);
    });

    tearDown(() async {
      await databaseDriver.close();
    });

    test("Test Method \"getUsers\" Returns Users Stored on Database", () async {
      List<UserEntity> listOfUsersFromDatabase =
          await userDataAccessObject.getUsers();

      expect(listOfUsersFromDatabase.length, 0);
    });

    test("Test Method \"createUser\" Creates User On Database", () async {
      await userDataAccessObject.createUser(USER_ENTITY_OBJECT);

      List<Map<String, dynamic>> userDatabaseQueryResult = await databaseDriver
          .query(
            USER_DATABASE_TABLE_NAME,
            where: "$USER_ID_COLUMN= ?",
            whereArgs: [USER_ID],
          );

      UserEntity userFromDatabase = UserEntity.getEntityFromMap(
        userDatabaseQueryResult.first,
      );

      expect(userFromDatabase.id, USER_ID);
      expect(userFromDatabase.username, USER_USERNAME);
    });
  });
}

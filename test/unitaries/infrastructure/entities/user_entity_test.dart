import "package:flutter_test/flutter_test.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/infrastructure/entities/user_entity.dart";

void main() {
  group("Test Class UserEntity", () {
    test("Test If Entity Describes How Data Stored On Database", () {
      UserEntity instance = UserEntity(USER_ID, USER_USERNAME);

      expect(instance.id, USER_ID);
      expect(instance.username, USER_USERNAME);
    });

    test("Test Method \"getMap\" Returns Map Of User Data", () {
      UserEntity instance = UserEntity(USER_ID, USER_USERNAME);

      Map<String, dynamic> map = {
        USER_ID_COLUMN: USER_ID,
        USER_USERNAME_COLUMN: USER_USERNAME,
      };

      expect(instance.getMap(), map);
    });

    test("Test Method \"getModel\" Returns External Model Of User Data", () {
      UserEntity instance = UserEntity(USER_ID, USER_USERNAME);

      expect(instance.id, USER_MODEL_OBJECT.id);
      expect(instance.username, USER_MODEL_OBJECT.username);
    });

    test(
      "Test Method \"getEntityFromMap\" Returns Entity Instance From An User Map",
      () {
        Map<String, dynamic> map = USER_ENTITY_OBJECT.getMap();

        UserEntity instance = UserEntity.getEntityFromMap(map);

        expect(instance.id, USER_ID);
        expect(instance.username, USER_USERNAME);
      },
    );
  });
}

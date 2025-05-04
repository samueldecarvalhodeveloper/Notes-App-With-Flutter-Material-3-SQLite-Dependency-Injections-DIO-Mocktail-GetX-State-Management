import "package:flutter_test/flutter_test.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/infrastructure/entities/user_entity.dart";
import "package:notes_app/infrastructure/models/user.dart";

void main() {
  group("Test Class User", () {
    test(
      "Test If Model Describes How Data Should be handled By The System",
      () {
        User instance = User(USER_ID, USER_USERNAME);

        expect(instance.id, USER_ID);
        expect(instance.username, USER_USERNAME);
      },
    );

    test(
      "Test Method \"getModelFromMap\" Returns Model Instance From An User Map",
      () {
        Map<String, dynamic> map = {
          USER_ID_COLUMN: USER_ID,
          USER_USERNAME_COLUMN: USER_USERNAME,
        };

        User instance = User.getModelFromMap(map);

        expect(instance.id, USER_ID);
        expect(instance.username, USER_USERNAME);
      },
    );

    test(
      "Test Method \"getEntity\" Returns Database Entity With Model Data",
      () {
        UserEntity instance = USER_MODEL_OBJECT.getEntity();

        expect(instance.id, USER_ID);
        expect(instance.username, USER_USERNAME);
      },
    );
  });
}

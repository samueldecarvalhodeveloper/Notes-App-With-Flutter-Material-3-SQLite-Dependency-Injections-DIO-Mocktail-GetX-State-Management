import "package:flutter_test/flutter_test.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/infrastructure/data_transfer_objects/user_data_transfer_object.dart";

void main() {
  group("Test Class UserDataTransferObject", () {
    test(
      "Test If Class Describes How Data Should Be Transferred To The Service",
      () {
        UserDataTransferObject instance = UserDataTransferObject(USER_USERNAME);

        expect(instance.username, USER_USERNAME);
      },
    );

    test("Test Method \"getMap\" Returns Map Of User Data", () {
      UserDataTransferObject instance = UserDataTransferObject(USER_USERNAME);

      Map map = instance.getMap();

      expect(map[USER_USERNAME_RESPONSE_FIELD], USER_USERNAME);
    });
  });
}

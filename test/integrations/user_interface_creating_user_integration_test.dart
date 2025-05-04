import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:mocktail/mocktail.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/constants/user_interface_constants.dart";
import "package:notes_app/infrastructure/models/user.dart";
import "package:notes_app/repositories/user_repository.dart";
import "package:notes_app/screens/user_sign_in_screen.dart";
import "package:notes_app/controllers/user_controller.dart";
import "../mocks/user_repository_mock.dart";

void main() {
  group("Test User Interface Creating User Integration", () {
    late UserRepository userRepository;
    late UserController userController;

    testWidgets("Test User Interface Creating User", (
      WidgetTester tester,
    ) async {
      bool isUserCreated = false;

      userRepository = UserRepositoryMock();

      when(() => userRepository.getUser()).thenAnswer((_) async {
        return User(USER_ID, USER_USERNAME);
      });

      userController = UserController(userRepository);

      await tester.pumpWidget(
        MaterialApp(
          home: UserSignInScreen(userController, () {
            isUserCreated = true;
          }),
        ),
      );

      await tester.enterText(find.byType(TextField), USER_USERNAME);

      await tester.tap(find.text(CREATE_USER_BUTTON_TEXT));

      User createdUser = await userRepository.getUser();

      expect(createdUser.id, USER_ID);
      expect(createdUser.username, USER_USERNAME);

      expect(isUserCreated, isTrue);
    });
  });
}

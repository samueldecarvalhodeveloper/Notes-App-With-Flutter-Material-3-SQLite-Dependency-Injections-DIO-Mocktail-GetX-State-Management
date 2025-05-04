import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:notes_app/infrastructure/models/user.dart";
import "package:notes_app/repositories/user_repository.dart";

class UserController extends GetxController {
  final UserRepository _userRepository;
  Rxn<User> user = Rxn<User>();
  RxBool isInternetErrorRisen = false.obs;
  RxBool isUserUsernameInvalid = false.obs;
  RxBool isUserExistenceVerificationExecuted = false.obs;

  UserController(this._userRepository);

  Future<void> verifyIfUserExists(VoidCallback onUserCreated) async {
    try {
      User userFromDatabase = await _userRepository.getUser();

      user.value = userFromDatabase;

      onUserCreated();
    } catch (_) {
    } finally {
      isUserExistenceVerificationExecuted.value = true;
    }
  }

  Future<void> createUser(String username, VoidCallback onUserCreated) async {
    if (username.isEmpty) {
      isUserUsernameInvalid.value = true;
    } else {
      isUserUsernameInvalid.value = false;

      try {
        User createdUserOnService = await _userRepository.getCreatedUser(
          username,
        );

        user.value = createdUserOnService;

        onUserCreated();
      } catch (_) {
        isInternetErrorRisen.value = true;
      }
    }
  }
}

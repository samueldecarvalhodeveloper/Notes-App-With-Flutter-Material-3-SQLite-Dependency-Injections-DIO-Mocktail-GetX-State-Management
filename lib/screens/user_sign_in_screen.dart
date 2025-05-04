import "package:flutter/material.dart";
import "package:get/state_manager.dart";
import "package:notes_app/controllers/user_controller.dart";
import "package:notes_app/theme/colors.dart";

class UserSignInScreen extends StatelessWidget {
  final UserController _userController;
  final TextEditingController _usernameTextFieldController =
      TextEditingController();
  final VoidCallback _onUserExisting;

  UserSignInScreen(this._userController, this._onUserExisting, {super.key});

  @override
  Widget build(BuildContext context) {
    if (!_userController.isUserExistenceVerificationExecuted.value) {
      _userController.verifyIfUserExists(() {
        _onUserExisting();
      });
    }

    return Scaffold(
      backgroundColor: PRIMARY_500,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(24.0),
                decoration: BoxDecoration(
                  color: NEUTRALS_100,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Obx(
                      () => TextField(
                        controller: _usernameTextFieldController,
                        decoration: InputDecoration(
                          labelText: "Username",
                          labelStyle: TextStyle(color: PRIMARY_500),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PRIMARY_500),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: PRIMARY_500),
                          ),
                          errorText:
                              _userController.isUserUsernameInvalid.value
                                  ? "Not valid username"
                                  : (_userController.isInternetErrorRisen.value
                                      ? "No internet connection"
                                      : null),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: SECONDARY_500,
                          foregroundColor: SECONDARY_900,
                        ),
                        onPressed: () async {
                          await _userController.createUser(
                            _usernameTextFieldController.text,
                            () {
                              _onUserExisting();
                            },
                          );
                        },
                        child: const Text("Create user"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

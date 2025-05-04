import "package:flutter/material.dart";
import "package:get/get_navigation/get_navigation.dart";
import "package:get/instance_manager.dart";
import "package:notes_app/constants/user_interface_constants.dart";
import "package:notes_app/screens/note_editing_screen.dart";
import "package:notes_app/screens/notes_listing_screen.dart";
import "package:notes_app/screens/user_sign_in_screen.dart";
import "package:notes_app/controllers/note_editing_controller.dart";
import "package:notes_app/controllers/notes_listing_controller.dart";
import "package:notes_app/controllers/user_controller.dart";

class Application extends StatelessWidget {
  final UserController _userController = Get.find<UserController>();
  final NoteEditingController _noteEditingController =
      Get.find<NoteEditingController>();
  final NotesListingController _notesListingController =
      Get.find<NotesListingController>();

  Application({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: USER_SIGN_IN_SCREEN,
      getPages: [
        GetPage(
          name: USER_SIGN_IN_SCREEN,
          page: () {
            return UserSignInScreen(_userController, () {
              Get.toNamed(NOTES_LISTING_SCREEN);
            });
          },
        ),
        GetPage(
          name: NOTES_LISTING_SCREEN,
          page: () {
            return NotesListingScreen(
              _notesListingController,
              _userController,
              (int noteId) {
                Get.toNamed(NOTE_MANIPULATING_SCREEN, arguments: noteId);
              },
            );
          },
        ),
        GetPage(
          name: NOTE_MANIPULATING_SCREEN,
          page: () {
            int noteId = Get.arguments;

            return NoteManipulatingScreen(noteId, _noteEditingController, () {
              Get.toNamed(NOTES_LISTING_SCREEN);
            });
          },
        ),
      ],
    );
  }
}

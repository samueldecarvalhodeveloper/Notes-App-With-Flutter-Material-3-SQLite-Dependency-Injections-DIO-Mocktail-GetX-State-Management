import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:notes_app/components/create_note_floating_action_button.dart";
import "package:notes_app/components/greeting_app_bar.dart";
import "package:notes_app/sections/list_of_notes_section.dart";
import "package:notes_app/sections/loading_section.dart";
import "package:notes_app/sections/no_notes_section.dart";
import "package:notes_app/controllers/notes_listing_controller.dart";
import "package:notes_app/controllers/user_controller.dart";
import "package:notes_app/theme/colors.dart";

class NotesListingScreen extends StatelessWidget {
  final UserController _userController;
  final NotesListingController _notesListingController;
  final Function(int noteId) _onNoteSelected;

  NotesListingScreen(
    this._notesListingController,
    this._userController,
    this._onNoteSelected, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!_notesListingController.isListOfNotesLoaded.value) {
      _notesListingController.loadNotes(_userController.user.value!.id);
    }

    return Scaffold(
      backgroundColor: NEUTRALS_100,
      appBar: GreetingAppBar(_userController.user.value!.username),
      floatingActionButton: Obx(() {
        if (_notesListingController.isNoteCreationCurrentlyAble.value &&
            _notesListingController.isListOfNotesLoaded.value) {
          return CreateNoteFloatingActionButton(
            onNoteCreated: () {
              _notesListingController.createNote(
                _userController.user.value!.id,
                (noteId) {
                  _onNoteSelected(noteId);
                },
              );
            },
          );
        }

        return const SizedBox.shrink();
      }),
      body: Obx(() {
        if (_notesListingController.isListOfNotesLoaded.value) {
          if (_notesListingController.listOfNotes.isEmpty) {
            return const NoNotesSection();
          } else {
            return ListOfNotesSection(
              listOfNotes: _notesListingController.listOfNotes,
              onNoteItemClick: (noteId) {
                _onNoteSelected(noteId);
              },
            );
          }
        } else {
          return const LoadingSection();
        }
      }),
    );
  }
}

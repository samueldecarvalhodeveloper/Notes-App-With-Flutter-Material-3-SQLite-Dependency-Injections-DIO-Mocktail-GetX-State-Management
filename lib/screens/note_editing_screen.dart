import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:notes_app/components/note_manipulation_app_bar.dart";
import "package:notes_app/sections/loading_section.dart";
import "package:notes_app/sections/note_editing_section.dart";
import "package:notes_app/sections/note_visualizing_section.dart";
import "package:notes_app/controllers/note_editing_controller.dart";

class NoteManipulatingScreen extends StatelessWidget {
  final NoteEditingController _noteEditingController;
  final int _noteId;
  final Function _onNoteEditingConclusion;

  NoteManipulatingScreen(
    this._noteId,
    this._noteEditingController,
    this._onNoteEditingConclusion, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (!_noteEditingController.isNoteLoaded.value) {
      _noteEditingController.loadNote(_noteId);
    }

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Obx(
          () => NoteManipulationAppBar(
            _noteEditingController.isNoteManipulationAble.value &&
                _noteEditingController.isNoteLoaded.value &&
                !_noteEditingController.isNoteBeingManipulated.value,
            _noteEditingController.isNoteManipulationAble.value &&
                _noteEditingController.isNoteLoaded.value &&
                _noteEditingController.isNoteBeingManipulated.value,
            _noteEditingController.isNoteManipulationAble.value &&
                _noteEditingController.isNoteLoaded.value,
            () {
              _onNoteEditingConclusion();
            },
            () {
              _noteEditingController.concludeNote();
            },
            () {
              _noteEditingController.manipulateNote();
            },
            () {
              _noteEditingController.deleteNote(() {
                _onNoteEditingConclusion();
              });
            },
          ),
        ),
      ),
      body: Obx(() {
        if (_noteEditingController.isNoteLoaded.value) {
          if (_noteEditingController.isNoteBeingManipulated.value) {
            return NoteEditingSection(
              note: _noteEditingController.note.value!,
              onNoteTitleChange: (changedNoteTitle) {
                _noteEditingController.setNoteTitle(changedNoteTitle);
              },
              onNoteBodyChange: (changedNoteBody) {
                _noteEditingController.setNoteBody(changedNoteBody);
              },
            );
          } else {
            return NoteVisualizingSection(
              note: _noteEditingController.note.value!,
            );
          }
        } else {
          return const LoadingSection();
        }
      }),
    );
  }
}

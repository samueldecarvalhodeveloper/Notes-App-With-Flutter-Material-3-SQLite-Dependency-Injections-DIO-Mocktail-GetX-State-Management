import "package:flutter/material.dart";
import "package:notes_app/constants/user_interface_constants.dart";
import "package:notes_app/theme/colors.dart";

class CreateNoteFloatingActionButton extends StatelessWidget {
  final VoidCallback onNoteCreated;

  const CreateNoteFloatingActionButton({
    required this.onNoteCreated,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: onNoteCreated,
      label: Text("Create note"),
      icon: Icon(Icons.create),
      backgroundColor: SECONDARY_500,
      foregroundColor: SECONDARY_900,
      tooltip: CREATE_NOTE_FLOATING_ACTION_BUTTON_TEXT,
    );
  }
}

import "package:flutter/material.dart";
import "package:notes_app/components/note_item.dart";
import "package:notes_app/infrastructure/models/note.dart";

class ListOfNotesSection extends StatelessWidget {
  final List<Note> listOfNotes;
  final void Function(int) onNoteItemClick;

  const ListOfNotesSection({
    required this.listOfNotes,
    required this.onNoteItemClick,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: listOfNotes.length,
      itemBuilder: (context, index) {
        final note = listOfNotes[index];

        return NoteItem(
          title: note.title,
          body: note.body,
          onTap: () {
            onNoteItemClick(note.id);
          },
        );
      },
    );
  }
}

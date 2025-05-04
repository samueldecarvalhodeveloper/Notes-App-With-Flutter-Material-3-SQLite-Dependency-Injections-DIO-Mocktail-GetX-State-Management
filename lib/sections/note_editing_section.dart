import "package:flutter/material.dart";
import "package:notes_app/infrastructure/models/note.dart";
import "package:notes_app/theme/colors.dart";

class NoteEditingSection extends StatelessWidget {
  final Note note;
  final ValueChanged<String> onNoteTitleChange;
  final ValueChanged<String> onNoteBodyChange;

  const NoteEditingSection({
    required this.note,
    required this.onNoteTitleChange,
    required this.onNoteBodyChange,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: TextEditingController(text: note.title),
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(
                top: 17.5,
                left: 16,
                right: 16,
              ),
              hintText: "Title",
              hintStyle: TextStyle(
                color: NEUTRALS_300,
                fontSize: 40.0,
                height: 40.0 / 40.0,
                letterSpacing: 0.0,
              ),
              border: InputBorder.none,
            ),
            style: TextStyle(
              color: NEUTRALS_900,
              fontSize: 40.0,
              letterSpacing: 0.0,
            ),
            maxLines: 1,
            onChanged: onNoteTitleChange,
          ),
          SizedBox(height: 8),
          Expanded(
            child: TextField(
              controller: TextEditingController(text: note.body),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.only(top: 14, left: 16, right: 16),
                hintText: "Body",
                hintStyle: TextStyle(
                  color: NEUTRALS_300,
                  fontSize: 16.0,
                  letterSpacing: 0.5,
                ),
                border: InputBorder.none,
              ),
              style: TextStyle(
                color: NEUTRALS_900,
                fontSize: 16.0,
                letterSpacing: 0.5,
              ),
              onChanged: onNoteBodyChange,
            ),
          ),
        ],
      ),
    );
  }
}

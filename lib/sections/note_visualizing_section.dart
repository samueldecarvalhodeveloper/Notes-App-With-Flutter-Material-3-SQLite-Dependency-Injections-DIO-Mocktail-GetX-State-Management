import "package:flutter/material.dart";
import "package:notes_app/infrastructure/models/note.dart";
import "package:notes_app/theme/colors.dart";

class NoteVisualizingSection extends StatelessWidget {
  final Note note;

  const NoteVisualizingSection({required this.note, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: Text(
                note.title,
                style: TextStyle(
                  color: NEUTRALS_900,
                  fontSize: 40.0,
                  letterSpacing: 0.0,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Text(
                  note.body,
                  style: TextStyle(
                    color: NEUTRALS_900,
                    fontSize: 16.0,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import "package:flutter/material.dart";
import "package:notes_app/theme/colors.dart";

class NoNotesSection extends StatelessWidget {
  const NoNotesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "No notes",
        style: TextStyle(fontSize: 14.0, color: NEUTRALS_300),
      ),
    );
  }
}

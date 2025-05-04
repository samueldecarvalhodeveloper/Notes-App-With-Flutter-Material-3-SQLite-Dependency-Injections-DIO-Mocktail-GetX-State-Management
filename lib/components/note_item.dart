import "package:flutter/material.dart";
import "package:notes_app/theme/colors.dart";

class NoteItem extends StatelessWidget {
  final String title;
  final String body;
  final void Function() onTap;

  const NoteItem({
    required this.title,
    required this.body,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16.0,
                    height: 1.5,
                    letterSpacing: 0.5,
                    color: NEUTRALS_900,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  body,
                  style: TextStyle(
                    fontSize: 14.0,
                    height: 1.428,
                    letterSpacing: 0.25,
                    color: NEUTRALS_500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Divider(thickness: 1.0, color: NEUTRALS_200),
        ],
      ),
    );
  }
}

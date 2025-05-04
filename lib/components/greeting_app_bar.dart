import "package:flutter/material.dart";
import "package:notes_app/theme/colors.dart";

class GreetingAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String _userUsername;

  GreetingAppBar(this._userUsername, {super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PRIMARY_500,
      titleTextStyle: TextStyle(color: NEUTRALS_100),
      title: Text("Hello, $_userUsername"),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

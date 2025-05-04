import "package:flutter/material.dart";
import "package:notes_app/constants/user_interface_constants.dart";
import "package:notes_app/theme/colors.dart";

class LoadingSection extends StatelessWidget {
  const LoadingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Semantics(
        label: LOADING_SECTION_TOOLTIP,
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(PRIMARY_500),
        ),
      ),
    );
  }
}

import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:notes_app/components/note_manipulation_app_bar.dart";
import "package:notes_app/constants/user_interface_constants.dart";

void main() {
  group("Test Component NoteManipulationAppBar", () {
    testWidgets("Test If Buttons Are Displayed And Dispatch Actions On Tap", (
      WidgetTester tester,
    ) async {
      bool isBackButtonTapped = false;
      bool isEditButtonTapped = false;
      bool isDeleteButtonTapped = false;
      bool isConcludeButtonTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: NoteManipulationAppBar(
              true,
              true,
              true,
              () {
                isBackButtonTapped = true;
              },
              () {
                isEditButtonTapped = true;
              },
              () {
                isDeleteButtonTapped = true;
              },
              () {
                isConcludeButtonTapped = true;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.byTooltip(BACK_BUTTON_TOOLTIP));
      await tester.tap(find.byTooltip(EDIT_NOTE_TOOLTIP));
      await tester.tap(find.byTooltip(DELETE_NOTE_TOOLTIP));
      await tester.tap(find.byTooltip(CONCLUDE_NOTE_BUTTON_TOOLTIP));

      expect(isBackButtonTapped, isTrue);
      expect(isEditButtonTapped, isTrue);
      expect(isDeleteButtonTapped, isTrue);
      expect(isConcludeButtonTapped, isTrue);
    });
  });
}

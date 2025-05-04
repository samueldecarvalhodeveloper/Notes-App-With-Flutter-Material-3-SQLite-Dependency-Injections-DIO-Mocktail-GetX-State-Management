import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:notes_app/components/create_note_floating_action_button.dart";
import "package:notes_app/constants/user_interface_constants.dart";

void main() {
  group("Test Component CreateNoteFloatingActionButton", () {
    testWidgets("Test If Component Is Displayed And Triggers Callback On Tap", (
      WidgetTester tester,
    ) async {
      bool isWidgetTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            floatingActionButton: CreateNoteFloatingActionButton(
              onNoteCreated: () {
                isWidgetTapped = true;
              },
            ),
          ),
        ),
      );

      expect(find.byType(FloatingActionButton), findsOneWidget);
      expect(
        find.text(CREATE_NOTE_FLOATING_ACTION_BUTTON_TEXT),
        findsOneWidget,
      );
      expect(find.byIcon(Icons.create), findsOneWidget);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();

      expect(isWidgetTapped, isTrue);
    });
  });
}

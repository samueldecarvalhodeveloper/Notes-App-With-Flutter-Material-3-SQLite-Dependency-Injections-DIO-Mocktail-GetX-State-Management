import "dart:convert";
import "package:flutter_test/flutter_test.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/infrastructure/entities/note_entity.dart";
import "package:notes_app/infrastructure/models/note.dart";

void main() {
  group("Test Class Note", () {
    test(
      "Test If Model Describes How Data Should be handled By The System",
      () {
        Note instance = Note(
          NOTE_ID,
          NOTE_TITLE,
          NOTE_BODY,
          NOTE_CREATED_AT,
          NOTE_UPDATED_AT,
          USER_ID,
        );

        expect(instance.id, NOTE_ID);
        expect(instance.title, NOTE_TITLE);
        expect(instance.body, NOTE_BODY);
        expect(instance.createdAt, NOTE_CREATED_AT);
        expect(instance.updatedAt, NOTE_UPDATED_AT);
        expect(instance.userId, USER_ID);
      },
    );

    test(
      "Test Method \"getModelFromMap\" Returns Model Instance From A Note Map",
      () {
        Map<String, dynamic> map = {
          NOTE_ID_COLUMN: NOTE_ID,
          NOTE_TITLE_COLUMN: NOTE_TITLE,
          NOTE_BODY_COLUMN: NOTE_BODY,
          NOTE_CREATED_AT_COLUMN: NOTE_CREATED_AT,
          NOTE_UPDATED_AT_COLUMN: NOTE_UPDATED_AT,
          NOTE_USER_ID_COLUMN: USER_ID,
        };

        Note instance = Note.getModelFromMap(map);

        expect(instance.id, NOTE_ID);
        expect(instance.title, NOTE_TITLE);
        expect(instance.body, NOTE_BODY);
        expect(instance.createdAt, NOTE_CREATED_AT);
        expect(instance.updatedAt, NOTE_UPDATED_AT);
        expect(instance.userId, USER_ID);
      },
    );

    test(
      "Test Method \"getJson\" Returns String Json Representation Of Note Data",
      () {
        String jsonRepresentationOfNote = jsonEncode({
          NOTE_ID_COLUMN: NOTE_ID,
          NOTE_TITLE_COLUMN: NOTE_TITLE,
          NOTE_BODY_COLUMN: NOTE_BODY,
          NOTE_CREATED_AT_COLUMN: NOTE_CREATED_AT,
          NOTE_UPDATED_AT_COLUMN: NOTE_UPDATED_AT,
          NOTE_USER_ID_COLUMN: USER_ID,
        });

        String jsonRepresentationOfNoteFromInstance =
            NOTE_MODEL_OBJECT.getJson();

        expect(jsonRepresentationOfNoteFromInstance, jsonRepresentationOfNote);
      },
    );

    test(
      "Test Method \"getEntity\" Returns Database Entity With Model Data",
      () {
        NoteEntity instance = NOTE_MODEL_OBJECT.getEntity();

        expect(instance.id, NOTE_ID);
        expect(instance.title, NOTE_TITLE);
        expect(instance.body, NOTE_BODY);
        expect(instance.createdAt, NOTE_CREATED_AT);
        expect(instance.updatedAt, NOTE_UPDATED_AT);
        expect(instance.userId, USER_ID);
      },
    );
  });
}

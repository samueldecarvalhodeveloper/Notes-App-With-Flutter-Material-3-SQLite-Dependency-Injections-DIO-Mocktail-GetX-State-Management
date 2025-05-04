import "package:flutter_test/flutter_test.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/infrastructure/entities/note_entity.dart";

void main() {
  group("Test Class NoteEntity", () {
    test("Test If Entity Describes How Data Stored On Database", () {
      NoteEntity instance = NoteEntity(
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
    });

    test("Test Method \"getMap\" Returns Map Of Note Data", () {
      NoteEntity instance = NoteEntity(
        NOTE_ID,
        NOTE_TITLE,
        NOTE_BODY,
        NOTE_CREATED_AT,
        NOTE_UPDATED_AT,
        USER_ID,
      );

      Map<String, dynamic> map = {
        NOTE_ID_COLUMN: NOTE_ID,
        NOTE_TITLE_COLUMN: NOTE_TITLE,
        NOTE_BODY_COLUMN: NOTE_BODY,
        NOTE_CREATED_AT_COLUMN: NOTE_CREATED_AT,
        NOTE_UPDATED_AT_COLUMN: NOTE_UPDATED_AT,
        NOTE_USER_ID_COLUMN: USER_ID,
      };

      expect(instance.getMap(), map);
    });

    test("Test Method \"getModel\" Returns External Model Of Note Data", () {
      NoteEntity instance = NoteEntity(
        NOTE_ID,
        NOTE_TITLE,
        NOTE_BODY,
        NOTE_CREATED_AT,
        NOTE_UPDATED_AT,
        USER_ID,
      );

      expect(instance.id, NOTE_MODEL_OBJECT.id);
      expect(instance.title, NOTE_MODEL_OBJECT.title);
      expect(instance.body, NOTE_MODEL_OBJECT.body);
      expect(instance.createdAt, NOTE_MODEL_OBJECT.createdAt);
      expect(instance.updatedAt, NOTE_MODEL_OBJECT.updatedAt);
      expect(instance.userId, NOTE_MODEL_OBJECT.userId);
    });

    test(
      "Test Method \"getEntityFromMap\" Returns Entity Instance From A Note Map",
      () {
        Map<String, dynamic> map = NOTE_ENTITY_OBJECT.getMap();

        NoteEntity instance = NoteEntity.getEntityFromMap(map);

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

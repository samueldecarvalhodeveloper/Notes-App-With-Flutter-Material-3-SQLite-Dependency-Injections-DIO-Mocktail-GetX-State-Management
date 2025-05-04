import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/infrastructure/models/note.dart";

class NoteEntity {
  int id;
  String title;
  String body;
  int createdAt;
  int updatedAt;
  int userId;

  NoteEntity(
    this.id,
    this.title,
    this.body,
    this.createdAt,
    this.updatedAt,
    this.userId,
  );

  static NoteEntity getEntityFromMap(Map<String, dynamic> map) {
    return NoteEntity(
      map[NOTE_ID_COLUMN],
      map[NOTE_TITLE_COLUMN],
      map[NOTE_BODY_COLUMN],
      map[NOTE_CREATED_AT_COLUMN],
      map[NOTE_UPDATED_AT_COLUMN],
      map[NOTE_USER_ID_COLUMN],
    );
  }

  Map<String, dynamic> getMap() {
    return {
      NOTE_ID_COLUMN: id,
      NOTE_TITLE_COLUMN: title,
      NOTE_BODY_COLUMN: body,
      NOTE_CREATED_AT_COLUMN: createdAt,
      NOTE_UPDATED_AT_COLUMN: updatedAt,
      NOTE_USER_ID_COLUMN: userId,
    };
  }

  Note getModel() {
    return Note(id, title, body, createdAt, updatedAt, userId);
  }
}

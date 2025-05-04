import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/infrastructure/data_transfer_objects/note_data_transfer_object.dart";
import "package:notes_app/infrastructure/entities/note_entity.dart";
import "package:notes_app/infrastructure/models/note.dart";

const NOTE_DATABASE_TABLE_NAME = "notes";

const NOTE_DATABASE_CREATION_QUERY = """
CREATE TABLE IF NOT EXISTS notes (
  id INTEGER PRIMARY KEY NOT NULL,
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  created_at INTEGER NOT NULL,
  updated_at INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id)
);""";

const NOTE_ID_COLUMN = "id";

const NOTE_TITLE_COLUMN = "title";

const NOTE_BODY_COLUMN = "body";

const NOTE_CREATED_AT_COLUMN = "created_at";

const NOTE_UPDATED_AT_COLUMN = "updated_at";

const NOTE_USER_ID_COLUMN = "user_id";

const NOTE_TITLE_RESPONSE_FIELD = "title";

const NOTE_BODY_RESPONSE_FIELD = "body";

const NOTE_BASE_ROUTE = "/notes";

const NOTE_ID = 20;

const NOTE_TITLE = "Title";

const NOTE_BODY = "Body";

const NOTE_CREATED_AT = 0;

const NOTE_UPDATED_AT = 0;

final NOTE_ENTITY_OBJECT = NoteEntity(
  NOTE_ID,
  NOTE_TITLE,
  NOTE_BODY,
  NOTE_CREATED_AT,
  NOTE_UPDATED_AT,
  USER_ID,
);

final NOTE_ENTITY_WITH_WRONG_DATA_OBJECT = NoteEntity(
  NOTE_ID,
  "",
  "",
  NOTE_CREATED_AT,
  NOTE_UPDATED_AT,
  USER_ID,
);

final NOTE_MODEL_OBJECT = Note(
  NOTE_ID,
  NOTE_TITLE,
  NOTE_BODY,
  NOTE_CREATED_AT,
  NOTE_UPDATED_AT,
  USER_ID,
);

final NOTE_DATA_TRANSFER_OBJECT_OBJECT = NoteDataTransferObject(
  NOTE_TITLE,
  NOTE_BODY,
);

final NOTE_DATA_TRANSFER_OBJECT_WITH_WRONG_DATA_OBJECT = NoteDataTransferObject(
  "",
  "",
);

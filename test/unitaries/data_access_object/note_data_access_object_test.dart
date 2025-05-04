import "package:flutter_test/flutter_test.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/data_access_objects/note_data_access_object.dart";
import "package:notes_app/infrastructure/entities/note_entity.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

void main() {
  group("Test Class NoteDataAccessObject", () {
    late Database databaseDriver;
    late NoteDataAccessObject noteDataAccessObject;

    setUp(() async {
      sqfliteFfiInit();

      databaseFactory = databaseFactoryFfi;
      databaseDriver = await databaseFactory.openDatabase(inMemoryDatabasePath);

      await databaseDriver.execute(NOTE_DATABASE_CREATION_QUERY);

      noteDataAccessObject = NoteDataAccessObject(databaseDriver);
    });

    tearDown(() async {
      await databaseDriver.close();
    });

    test("Test Method \"getNotes\" Returns Notes Stored on Database", () async {
      List<NoteEntity> listOfNotesFromDatabase =
          await noteDataAccessObject.getNotes();

      expect(listOfNotesFromDatabase.length, 0);
    });

    test("Test Method \"getNote\" Returns Note Stored on Database", () async {
      await databaseDriver.insert(
        NOTE_DATABASE_TABLE_NAME,
        NOTE_ENTITY_OBJECT.getMap(),
      );

      NoteEntity noteFromDatabase = await noteDataAccessObject.getNote(NOTE_ID);

      expect(noteFromDatabase.id, NOTE_ID);
      expect(noteFromDatabase.title, NOTE_TITLE);
      expect(noteFromDatabase.body, NOTE_BODY);
      expect(noteFromDatabase.createdAt, NOTE_CREATED_AT);
      expect(noteFromDatabase.updatedAt, NOTE_UPDATED_AT);
      expect(noteFromDatabase.userId, USER_ID);
    });

    test("Test Method \"createNote\" Creates Note On Database", () async {
      await noteDataAccessObject.createNote(NOTE_ENTITY_OBJECT);

      List<Map<String, dynamic>> noteDatabaseQueryResult = await databaseDriver
          .query(
            NOTE_DATABASE_TABLE_NAME,
            where: "$NOTE_ID_COLUMN = ?",
            whereArgs: [NOTE_ID],
          );

      NoteEntity noteFromDatabase = NoteEntity.getEntityFromMap(
        noteDatabaseQueryResult.first,
      );

      expect(noteFromDatabase.id, NOTE_ID);
      expect(noteFromDatabase.title, NOTE_TITLE);
      expect(noteFromDatabase.body, NOTE_BODY);
      expect(noteFromDatabase.createdAt, NOTE_CREATED_AT);
      expect(noteFromDatabase.updatedAt, NOTE_UPDATED_AT);
      expect(noteFromDatabase.userId, USER_ID);
    });

    test("Test Method \"updateNote\" Updates Note On Database", () async {
      await databaseDriver.insert(
        NOTE_DATABASE_TABLE_NAME,
        NOTE_ENTITY_WITH_WRONG_DATA_OBJECT.getMap(),
      );

      await noteDataAccessObject.updateNote(NOTE_ENTITY_OBJECT);

      List<Map<String, dynamic>> noteDatabaseQueryResult = await databaseDriver
          .query(
            NOTE_DATABASE_TABLE_NAME,
            where: "$NOTE_ID_COLUMN = ?",
            whereArgs: [NOTE_ID],
          );

      NoteEntity noteFromDatabase = NoteEntity.getEntityFromMap(
        noteDatabaseQueryResult.first,
      );

      expect(noteFromDatabase.id, NOTE_ID);
      expect(noteFromDatabase.title, NOTE_TITLE);
      expect(noteFromDatabase.body, NOTE_BODY);
      expect(noteFromDatabase.createdAt, NOTE_CREATED_AT);
      expect(noteFromDatabase.updatedAt, NOTE_UPDATED_AT);
      expect(noteFromDatabase.userId, USER_ID);
    });

    test("Test Method \"deleteNote\" Deletes Note On Database", () async {
      await databaseDriver.insert(
        NOTE_DATABASE_TABLE_NAME,
        NOTE_ENTITY_OBJECT.getMap(),
      );

      await noteDataAccessObject.deleteNote(NOTE_ID);

      List<Map<String, dynamic>> noteDatabaseQueryResult = await databaseDriver
          .query(
            NOTE_DATABASE_TABLE_NAME,
            where: "$NOTE_ID_COLUMN = ?",
            whereArgs: [NOTE_ID],
          );

      expect(noteDatabaseQueryResult.length, 0);
    });
  });
}

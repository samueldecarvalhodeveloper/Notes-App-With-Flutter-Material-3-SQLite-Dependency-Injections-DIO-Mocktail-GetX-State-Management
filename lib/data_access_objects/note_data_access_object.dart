import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/infrastructure/entities/note_entity.dart";
import "package:sqflite/sqflite.dart";

class NoteDataAccessObject {
  final Database _databaseDriver;

  NoteDataAccessObject(this._databaseDriver);

  Future<List<NoteEntity>> getNotes() async {
    List<Map<String, dynamic>> listOfNotesFromDatabase = await _databaseDriver
        .query(NOTE_DATABASE_TABLE_NAME);

    return listOfNotesFromDatabase
        .map((map) => NoteEntity.getEntityFromMap(map))
        .toList();
  }

  Future<NoteEntity> getNote(int id) async {
    List<Map<String, dynamic>> listOfNotesFromDatabase = await _databaseDriver
        .query(
          NOTE_DATABASE_TABLE_NAME,
          where: "$NOTE_ID_COLUMN = ?",
          whereArgs: [id],
        );

    return NoteEntity.getEntityFromMap(listOfNotesFromDatabase.first);
  }

  Future<void> createNote(NoteEntity note) async {
    await _databaseDriver.insert(
      NOTE_DATABASE_TABLE_NAME,
      note.getMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateNote(NoteEntity note) async {
    await _databaseDriver.update(
      NOTE_DATABASE_TABLE_NAME,
      note.getMap(),
      where: "$NOTE_ID_COLUMN = ?",
      whereArgs: [note.id],
    );
  }

  Future<void> deleteNote(int id) async {
    await _databaseDriver.delete(
      NOTE_DATABASE_TABLE_NAME,
      where: "$NOTE_ID_COLUMN = ?",
      whereArgs: [id],
    );
  }
}

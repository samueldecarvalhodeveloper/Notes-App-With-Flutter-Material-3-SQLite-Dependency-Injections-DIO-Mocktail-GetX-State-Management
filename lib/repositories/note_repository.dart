import "package:notes_app/data_access_objects/note_data_access_object.dart";
import "package:notes_app/data_gateways/note_gateway.dart";
import "package:notes_app/infrastructure/data_transfer_objects/note_data_transfer_object.dart";
import "package:notes_app/infrastructure/entities/note_entity.dart";
import "package:notes_app/infrastructure/models/note.dart";

class NoteRepository {
  final NoteGateway _noteGateway;
  final NoteDataAccessObject _noteDataAccessObject;

  NoteRepository(this._noteGateway, this._noteDataAccessObject);

  Future<void> fetchNotesFromService(int userId) async {
    List<Note> notesFromService = await _noteGateway.getNotes(userId);
    List<NoteEntity> notesFromDatabase = await _noteDataAccessObject.getNotes();

    for (var note in notesFromDatabase) {
      await _noteDataAccessObject.deleteNote(note.id);
    }

    for (var note in notesFromService) {
      await _noteDataAccessObject.createNote(note.getEntity());
    }
  }

  Future<List<Note>> getNotes() async {
    List<NoteEntity> noteEntities = await _noteDataAccessObject.getNotes();

    return noteEntities.map((noteEntity) => noteEntity.getModel()).toList();
  }

  Future<Note> getNote(int id) async {
    NoteEntity noteEntity = await _noteDataAccessObject.getNote(id);

    return noteEntity.getModel();
  }

  Future<Note> getCreatedNote(String title, String body, int userId) async {
    NoteDataTransferObject noteDataTransferObject = NoteDataTransferObject(
      title,
      body,
    );

    Note createdNoteOnService = await _noteGateway.getCreatedNoteOnService(
      userId,
      noteDataTransferObject,
    );

    await _noteDataAccessObject.createNote(createdNoteOnService.getEntity());

    return createdNoteOnService;
  }

  Future<Note> getUpdatedNote(
    int id,
    String title,
    String body,
    int userId,
  ) async {
    NoteDataTransferObject noteDataTransferObject = NoteDataTransferObject(
      title,
      body,
    );

    Note updatedNoteOnService = await _noteGateway.getUpdatedNoteOnService(
      userId,
      id,
      noteDataTransferObject,
    );

    await _noteDataAccessObject.updateNote(updatedNoteOnService.getEntity());

    return updatedNoteOnService;
  }

  Future<void> deleteNote(int id, int userId) async {
    await _noteGateway.deleteNote(id, userId);

    await _noteDataAccessObject.deleteNote(id);
  }
}

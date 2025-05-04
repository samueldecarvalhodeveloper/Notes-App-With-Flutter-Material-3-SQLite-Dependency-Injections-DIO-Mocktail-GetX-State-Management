import "package:dio/dio.dart";
import "package:notes_app/constants/application_constants.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/infrastructure/data_transfer_objects/note_data_transfer_object.dart";
import "package:notes_app/infrastructure/models/note.dart";

class NoteGateway {
  final Dio _httpClientImplementation;

  NoteGateway(this._httpClientImplementation);

  Future<List<Note>> getNotes(int userId) async {
    Response requestResponse = await _httpClientImplementation.get(
      "$SERVICE_URL$NOTE_BASE_ROUTE/$userId/",
    );

    return (requestResponse.data as List<dynamic>)
        .map((map) => Note.getModelFromMap(map))
        .toList();
  }

  Future<Note> getCreatedNoteOnService(
    int userId,
    NoteDataTransferObject note,
  ) async {
    Response requestResponse = await _httpClientImplementation.post(
      "$SERVICE_URL$NOTE_BASE_ROUTE/$userId/",
      data: note.getMap(),
    );

    return Note.getModelFromMap(requestResponse.data);
  }

  Future<Note> getUpdatedNoteOnService(
    int userId,
    int noteId,
    NoteDataTransferObject note,
  ) async {
    Response requestResponse = await _httpClientImplementation.patch(
      "$SERVICE_URL$NOTE_BASE_ROUTE/$userId/$noteId/",
      data: note.getMap(),
    );

    return Note.getModelFromMap(requestResponse.data);
  }

  Future<void> deleteNote(int noteId, int userId) async {
    await _httpClientImplementation.delete(
      "$SERVICE_URL$NOTE_BASE_ROUTE/$userId/$noteId/",
    );
  }
}

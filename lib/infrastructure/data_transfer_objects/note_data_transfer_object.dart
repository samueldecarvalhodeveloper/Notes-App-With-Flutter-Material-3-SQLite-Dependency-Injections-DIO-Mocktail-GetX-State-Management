import "package:notes_app/constants/note_constants.dart";

class NoteDataTransferObject {
  String title;
  String body;

  NoteDataTransferObject(this.title, this.body);

  Map<String, dynamic> getMap() {
    return {NOTE_TITLE_RESPONSE_FIELD: title, NOTE_BODY_RESPONSE_FIELD: body};
  }
}

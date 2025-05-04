import "package:get/get.dart";
import "package:notes_app/infrastructure/models/note.dart";
import "package:notes_app/repositories/note_repository.dart";

class NotesListingController extends GetxController {
  final NoteRepository _noteRepository;
  RxList<Note> listOfNotes = <Note>[].obs;
  RxBool isListOfNotesLoaded = false.obs;
  RxBool isNoteCreationCurrentlyAble = true.obs;

  NotesListingController(this._noteRepository);

  Future<void> loadNotes(int userId) async {
    try {
      await _noteRepository.fetchNotesFromService(userId);
    } catch (_) {
    } finally {
      List<Note> listOfNotesFromDatabase = await _noteRepository.getNotes();

      listOfNotes.value = listOfNotesFromDatabase;

      isListOfNotesLoaded.value = true;
    }
  }

  Future<void> createNote(int userId, Function onNoteCreated) async {
    try {
      Note createdNote = await _noteRepository.getCreatedNote("", "", userId);

      onNoteCreated(createdNote.id);
    } catch (e) {
      isNoteCreationCurrentlyAble.value = false;
    }
  }
}

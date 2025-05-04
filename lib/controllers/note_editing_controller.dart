import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:notes_app/infrastructure/models/note.dart";
import "package:notes_app/repositories/note_repository.dart";

class NoteEditingController extends GetxController {
  final NoteRepository _noteRepository;
  Rxn<Note> note = Rxn<Note>();
  RxBool isNoteManipulationAble = true.obs;
  RxBool isNoteLoaded = false.obs;
  RxBool isNoteBeingManipulated = false.obs;
  String _noteTitleBeingManipulated = "";
  String _noteBodyBeingManipulated = "";

  NoteEditingController(this._noteRepository);

  Future<void> loadNote(int noteId) async {
    try {
      Note noteFromDatabase = await _noteRepository.getNote(noteId);

      _noteTitleBeingManipulated = noteFromDatabase.title;
      _noteBodyBeingManipulated = noteFromDatabase.body;

      note.value = noteFromDatabase;

      isNoteLoaded.value = true;
    } catch (e) {}
  }

  void manipulateNote() {
    isNoteBeingManipulated.value = isNoteManipulationAble.value;
  }

  void setNoteTitle(String title) {
    _noteTitleBeingManipulated = title;
  }

  void setNoteBody(String body) {
    _noteBodyBeingManipulated = body;
  }

  Future<void> concludeNote() async {
    try {
      Note updatedNoteOnService = await _noteRepository.getUpdatedNote(
        note.value!.id,
        _noteTitleBeingManipulated,
        _noteBodyBeingManipulated,
        note.value!.userId,
      );

      note.value = updatedNoteOnService;

      isNoteBeingManipulated.value = false;
    } catch (e) {
      isNoteManipulationAble.value = false;

      isNoteBeingManipulated.value = false;
    }
  }

  Future<void> deleteNote(VoidCallback onNoteDeleted) async {
    try {
      await _noteRepository.deleteNote(note.value!.id, note.value!.userId);

      onNoteDeleted();
    } catch (e) {
      isNoteManipulationAble.value = false;

      isNoteBeingManipulated.value = false;
    }
  }
}

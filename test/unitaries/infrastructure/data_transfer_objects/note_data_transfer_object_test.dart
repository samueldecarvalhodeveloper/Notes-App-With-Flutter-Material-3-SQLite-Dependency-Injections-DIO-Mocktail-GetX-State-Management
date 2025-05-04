import "package:flutter_test/flutter_test.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/infrastructure/data_transfer_objects/note_data_transfer_object.dart";

void main() {
  group("Test Class NoteDataTransferObject", () {
    test(
      "Test If Class Describes How Data Should Be Transferred To The Service",
      () {
        NoteDataTransferObject instance = NoteDataTransferObject(
          NOTE_TITLE,
          NOTE_BODY,
        );

        expect(instance.title, NOTE_TITLE);
        expect(instance.body, NOTE_BODY);
      },
    );

    test("Test Method \"getMap\" Returns Map Of Note Data", () {
      NoteDataTransferObject instance = NoteDataTransferObject(
        NOTE_TITLE,
        NOTE_BODY,
      );

      Map map = instance.getMap();

      expect(map[NOTE_TITLE_RESPONSE_FIELD], NOTE_TITLE);
      expect(map[NOTE_BODY_RESPONSE_FIELD], NOTE_BODY);
    });
  });
}

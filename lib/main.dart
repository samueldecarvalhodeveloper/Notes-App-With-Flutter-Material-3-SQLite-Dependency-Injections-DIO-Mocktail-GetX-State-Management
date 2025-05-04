import "package:dio/dio.dart";
import "package:flutter/material.dart";
import "package:get/get.dart";
import "package:notes_app/application/application.dart";
import "package:notes_app/constants/application_constants.dart";
import "package:notes_app/constants/note_constants.dart";
import "package:notes_app/constants/user_constants.dart";
import "package:notes_app/controllers/note_editing_controller.dart";
import "package:notes_app/controllers/notes_listing_controller.dart";
import "package:notes_app/controllers/user_controller.dart";
import "package:notes_app/data_access_objects/note_data_access_object.dart";
import "package:notes_app/data_access_objects/user_data_access_object.dart";
import "package:notes_app/data_gateways/note_gateway.dart";
import "package:notes_app/data_gateways/user_gateway.dart";
import "package:notes_app/repositories/note_repository.dart";
import "package:notes_app/repositories/user_repository.dart";
import "package:sqflite_common_ffi/sqflite_ffi.dart";

void main() async {
  Dio httpClientImplementation;
  Database databaseDriver;
  UserGateway userGateway;
  NoteGateway noteGateway;
  UserDataAccessObject userDataAccessObject;
  NoteDataAccessObject noteDataAccessObject;
  UserRepository userRepository;
  NoteRepository noteRepository;

  WidgetsFlutterBinding.ensureInitialized();

  sqfliteFfiInit();

  databaseFactory = databaseFactoryFfi;

  databaseDriver = await openDatabase(
    await DATABASE_FILE_PATH(),
    version: DATABASE_VERSION,
  );

  await databaseDriver.execute(USER_DATABASE_CREATION_QUERY);
  await databaseDriver.execute(NOTE_DATABASE_CREATION_QUERY);

  httpClientImplementation = Dio();

  userGateway = UserGateway(httpClientImplementation);
  noteGateway = NoteGateway(httpClientImplementation);

  userDataAccessObject = UserDataAccessObject(databaseDriver);
  noteDataAccessObject = NoteDataAccessObject(databaseDriver);

  userRepository = UserRepository(userGateway, userDataAccessObject);
  noteRepository = NoteRepository(noteGateway, noteDataAccessObject);

  Get.put<UserController>(UserController(userRepository), permanent: true);
  Get.put<NotesListingController>(NotesListingController(noteRepository));
  Get.put<NoteEditingController>(NoteEditingController(noteRepository));

  runApp(Application());
}

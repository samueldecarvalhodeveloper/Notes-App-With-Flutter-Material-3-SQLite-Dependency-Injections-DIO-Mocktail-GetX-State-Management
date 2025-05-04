import "package:path/path.dart";
import "package:sqflite/sqflite.dart";

Future<String> DATABASE_FILE_PATH() async {
  return join(await getDatabasesPath(), "application.db");
}

const DATABASE_VERSION = 1;

const SERVICE_URL = "http://10.0.2.2:3000";

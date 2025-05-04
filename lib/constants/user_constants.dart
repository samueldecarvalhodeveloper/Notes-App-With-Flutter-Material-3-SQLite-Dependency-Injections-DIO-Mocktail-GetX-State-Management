import "package:notes_app/infrastructure/data_transfer_objects/user_data_transfer_object.dart";
import "package:notes_app/infrastructure/entities/user_entity.dart";
import "package:notes_app/infrastructure/models/user.dart";

const USER_DATABASE_TABLE_NAME = "users";

const USER_DATABASE_CREATION_QUERY =
    "CREATE TABLE IF NOT EXISTS users(id INTEGER PRIMARY KEY NOT NULL, username TEXT NOT NULL)";

const USER_ID_COLUMN = "id";

const USER_USERNAME_COLUMN = "username";

const USER_USERNAME_RESPONSE_FIELD = "username";

const USER_BASE_ROUTE = "/users/";

const USER_ID = 10;

const USER_USERNAME = "username";

final USER_ENTITY_OBJECT = UserEntity(USER_ID, USER_USERNAME);

final USER_MODEL_OBJECT = User(USER_ID, USER_USERNAME);

final USER_DATA_TRANSFER_OBJECT_OBJECT = UserDataTransferObject(USER_USERNAME);

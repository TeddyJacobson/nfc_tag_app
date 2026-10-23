import 'dataconnect_generated/generated.dart';

import 'package:string_validator/string_validator.dart';

/// Length of valid tag ID strings.
const _tagIdLength = 32;


class IdNotFoundException implements Exception {
  final String? message;

  const IdNotFoundException(this.message);

  @override
  String toString() {
    return 'TagNotFoundException: $message';
  }
}


/// Returns backend tag data associated with a given tag id.
/// 
/// This function performs a call to the database, and thus it is recommended
/// to use `isTagIdFormatValid(id)` on the `id` string before using this function.
/// 
/// Throws [Exception] if there is no database entry for the provided `id`.
Future<GetTagByIdTag> getTagById(String id) async {
  final key = GetTagByIdVariablesKey(id: id);

  final result = await TagsConnector.instance.getTagById(key: key).execute();

  final tagData = result.data.tag;

  if (tagData == null) {
    throw IdNotFoundException('Provided id is not associated with a tag in database.');
  }

  return tagData;
}

/// Returns whether or not a tag id string is formatted correctly.
/// 
/// This function acts as a local first pass to check whether a string
/// could be an id associated with a tag in the database.
/// 
/// The current conditions are `length == _tagIdLength` and `isHexadecimal`.
bool isTagIdFormatValid(String id) {
  return id.length == _tagIdLength && isHexadecimal(id);
}

/// This function queries the backend for a hardcoded test id and prints the tag.
Future<void> getExampleTag() async {
  final tag = await getTagById('39749d59b89f46f3b5808c4879f43d53');
  print('CONNECTED TO FIREBASE:');
  print(tag.toJson());
}

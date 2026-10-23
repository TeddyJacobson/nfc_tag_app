import 'dataconnect_generated/generated.dart';

import 'package:string_validator/string_validator.dart';

const _tagIdLength = 32;

Future<GetTagByIdTag> getTagById(String id) async {
  final key = GetTagByIdVariablesKey(id: id);

  final result = await TagsConnector.instance.getTagById(key: key).execute();

  final tagData = result.data.tag;

  if (tagData == null) {
    // TODO: Throw custom exception type
    throw Exception("Invalid tag id provided");
  }

  return tagData;
}

bool isTagIdFormatValid(String id) {
  return id.length == _tagIdLength && isHexadecimal(id);
}

Future<void> getExampleTag() async {
  final tag = await getTagById("39749d59b89f46f3b5808c4879f43d53");
  print("CONNECTED TO FIREBASE:");
  print(tag.toJson());
}

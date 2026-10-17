part of 'generated.dart';

class CreateTestTagVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  CreateTestTagVariablesBuilder(this._dataConnect, );
  Deserializer<CreateTestTagData> dataDeserializer = (dynamic json)  => CreateTestTagData.fromJson(jsonDecode(json));
  
  Future<OperationResult<CreateTestTagData, void>> execute() {
    return ref().execute();
  }

  MutationRef<CreateTestTagData, void> ref() {
    
    return _dataConnect.mutation("CreateTestTag", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class CreateTestTagTagInsert {
  final String id;
  CreateTestTagTagInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateTestTagTagInsert otherTyped = other as CreateTestTagTagInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateTestTagTagInsert({
    required this.id,
  });
}

@immutable
class CreateTestTagData {
  final CreateTestTagTagInsert tag_insert;
  CreateTestTagData.fromJson(dynamic json):
  
  tag_insert = CreateTestTagTagInsert.fromJson(json['tag_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateTestTagData otherTyped = other as CreateTestTagData;
    return tag_insert == otherTyped.tag_insert;
    
  }
  @override
  int get hashCode => tag_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['tag_insert'] = tag_insert.toJson();
    return json;
  }

  CreateTestTagData({
    required this.tag_insert,
  });
}


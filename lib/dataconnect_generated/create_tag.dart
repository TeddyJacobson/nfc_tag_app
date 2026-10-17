part of 'generated.dart';

class CreateTagVariablesBuilder {
  double latitude;
  double longitude;
  String title;
  Optional<String> _description = Optional.optional(nativeFromJson, nativeToJson);

  final FirebaseDataConnect _dataConnect;  CreateTagVariablesBuilder description(String? t) {
   _description.value = t;
   return this;
  }

  CreateTagVariablesBuilder(this._dataConnect, {required  this.latitude,required  this.longitude,required  this.title,});
  Deserializer<CreateTagData> dataDeserializer = (dynamic json)  => CreateTagData.fromJson(jsonDecode(json));
  Serializer<CreateTagVariables> varsSerializer = (CreateTagVariables vars) => jsonEncode(vars.toJson());
  Future<OperationResult<CreateTagData, CreateTagVariables>> execute() {
    return ref().execute();
  }

  MutationRef<CreateTagData, CreateTagVariables> ref() {
    CreateTagVariables vars= CreateTagVariables(latitude: latitude,longitude: longitude,title: title,description: _description,);
    return _dataConnect.mutation("CreateTag", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class CreateTagTagInsert {
  final String id;
  CreateTagTagInsert.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateTagTagInsert otherTyped = other as CreateTagTagInsert;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  CreateTagTagInsert({
    required this.id,
  });
}

@immutable
class CreateTagData {
  final CreateTagTagInsert tag_insert;
  CreateTagData.fromJson(dynamic json):
  
  tag_insert = CreateTagTagInsert.fromJson(json['tag_insert']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateTagData otherTyped = other as CreateTagData;
    return tag_insert == otherTyped.tag_insert;
    
  }
  @override
  int get hashCode => tag_insert.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['tag_insert'] = tag_insert.toJson();
    return json;
  }

  CreateTagData({
    required this.tag_insert,
  });
}

@immutable
class CreateTagVariables {
  final double latitude;
  final double longitude;
  final String title;
  late final Optional<String>description;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  CreateTagVariables.fromJson(Map<String, dynamic> json):
  
  latitude = nativeFromJson<double>(json['latitude']),
  longitude = nativeFromJson<double>(json['longitude']),
  title = nativeFromJson<String>(json['title']) {
  
  
  
  
  
    description = Optional.optional(nativeFromJson, nativeToJson);
    description.value = json['description'] == null ? null : nativeFromJson<String>(json['description']);
  
  }
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final CreateTagVariables otherTyped = other as CreateTagVariables;
    return latitude == otherTyped.latitude && 
    longitude == otherTyped.longitude && 
    title == otherTyped.title && 
    description == otherTyped.description;
    
  }
  @override
  int get hashCode => Object.hashAll([latitude.hashCode, longitude.hashCode, title.hashCode, description.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['latitude'] = nativeToJson<double>(latitude);
    json['longitude'] = nativeToJson<double>(longitude);
    json['title'] = nativeToJson<String>(title);
    if(description.state == OptionalState.set) {
      json['description'] = description.toJson();
    }
    return json;
  }

  CreateTagVariables({
    required this.latitude,
    required this.longitude,
    required this.title,
    required this.description,
  });
}


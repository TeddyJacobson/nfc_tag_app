part of 'generated.dart';

class GetTagByIdVariablesBuilder {
  GetTagByIdVariablesKey key;

  final FirebaseDataConnect _dataConnect;
  GetTagByIdVariablesBuilder(this._dataConnect, {required  this.key,});
  Deserializer<GetTagByIdData> dataDeserializer = (dynamic json)  => GetTagByIdData.fromJson(jsonDecode(json));
  Serializer<GetTagByIdVariables> varsSerializer = (GetTagByIdVariables vars) => jsonEncode(vars.toJson());
  Future<QueryResult<GetTagByIdData, GetTagByIdVariables>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<GetTagByIdData, GetTagByIdVariables> ref() {
    GetTagByIdVariables vars= GetTagByIdVariables(key: key,);
    return _dataConnect.query("GetTagById", dataDeserializer, varsSerializer, vars);
  }
}

@immutable
class GetTagByIdTag {
  final String id;
  final double latitude;
  final double longitude;
  final String title;
  final String? description;
  final Timestamp creationTimestamp;
  GetTagByIdTag.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']),
  latitude = nativeFromJson<double>(json['latitude']),
  longitude = nativeFromJson<double>(json['longitude']),
  title = nativeFromJson<String>(json['title']),
  description = json['description'] == null ? null : nativeFromJson<String>(json['description']),
  creationTimestamp = Timestamp.fromJson(json['creationTimestamp']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetTagByIdTag otherTyped = other as GetTagByIdTag;
    return id == otherTyped.id && 
    latitude == otherTyped.latitude && 
    longitude == otherTyped.longitude && 
    title == otherTyped.title && 
    description == otherTyped.description && 
    creationTimestamp == otherTyped.creationTimestamp;
    
  }
  @override
  int get hashCode => Object.hashAll([id.hashCode, latitude.hashCode, longitude.hashCode, title.hashCode, description.hashCode, creationTimestamp.hashCode]);
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    json['latitude'] = nativeToJson<double>(latitude);
    json['longitude'] = nativeToJson<double>(longitude);
    json['title'] = nativeToJson<String>(title);
    if (description != null) {
      json['description'] = nativeToJson<String?>(description);
    }
    json['creationTimestamp'] = creationTimestamp.toJson();
    return json;
  }

  GetTagByIdTag({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    this.description,
    required this.creationTimestamp,
  });
}

@immutable
class GetTagByIdData {
  final GetTagByIdTag? tag;
  GetTagByIdData.fromJson(dynamic json):
  
  tag = json['tag'] == null ? null : GetTagByIdTag.fromJson(json['tag']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetTagByIdData otherTyped = other as GetTagByIdData;
    return tag == otherTyped.tag;
    
  }
  @override
  int get hashCode => tag.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    if (tag != null) {
      json['tag'] = tag!.toJson();
    }
    return json;
  }

  GetTagByIdData({
    this.tag,
  });
}

@immutable
class GetTagByIdVariablesKey {
  final String id;
  GetTagByIdVariablesKey.fromJson(dynamic json):
  
  id = nativeFromJson<String>(json['id']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetTagByIdVariablesKey otherTyped = other as GetTagByIdVariablesKey;
    return id == otherTyped.id;
    
  }
  @override
  int get hashCode => id.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['id'] = nativeToJson<String>(id);
    return json;
  }

  GetTagByIdVariablesKey({
    required this.id,
  });
}

@immutable
class GetTagByIdVariables {
  final GetTagByIdVariablesKey key;
  @Deprecated('fromJson is deprecated for Variable classes as they are no longer required for deserialization.')
  GetTagByIdVariables.fromJson(Map<String, dynamic> json):
  
  key = GetTagByIdVariablesKey.fromJson(json['key']);
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final GetTagByIdVariables otherTyped = other as GetTagByIdVariables;
    return key == otherTyped.key;
    
  }
  @override
  int get hashCode => key.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['key'] = key.toJson();
    return json;
  }

  GetTagByIdVariables({
    required this.key,
  });
}


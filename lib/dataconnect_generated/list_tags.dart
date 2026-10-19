part of 'generated.dart';

class ListTagsVariablesBuilder {
  
  final FirebaseDataConnect _dataConnect;
  ListTagsVariablesBuilder(this._dataConnect, );
  Deserializer<ListTagsData> dataDeserializer = (dynamic json)  => ListTagsData.fromJson(jsonDecode(json));
  
  Future<QueryResult<ListTagsData, void>> execute({QueryFetchPolicy fetchPolicy = QueryFetchPolicy.preferCache}) {
    return ref().execute(fetchPolicy: fetchPolicy);
  }

  QueryRef<ListTagsData, void> ref() {
    
    return _dataConnect.query("ListTags", dataDeserializer, emptySerializer, null);
  }
}

@immutable
class ListTagsTags {
  final String id;
  final double latitude;
  final double longitude;
  final String title;
  final String? description;
  final Timestamp creationTimestamp;
  ListTagsTags.fromJson(dynamic json):
  
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

    final ListTagsTags otherTyped = other as ListTagsTags;
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

  ListTagsTags({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.title,
    this.description,
    required this.creationTimestamp,
  });
}

@immutable
class ListTagsData {
  final List<ListTagsTags> tags;
  ListTagsData.fromJson(dynamic json):
  
  tags = (json['tags'] as List<dynamic>)
        .map((e) => ListTagsTags.fromJson(e))
        .toList();
  @override
  bool operator ==(Object other) {
    if(identical(this, other)) {
      return true;
    }
    if(other.runtimeType != runtimeType) {
      return false;
    }

    final ListTagsData otherTyped = other as ListTagsData;
    return tags == otherTyped.tags;
    
  }
  @override
  int get hashCode => tags.hashCode;
  

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {};
    json['tags'] = tags.map((e) => e.toJson()).toList();
    return json;
  }

  ListTagsData({
    required this.tags,
  });
}


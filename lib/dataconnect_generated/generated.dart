library dataconnect_generated;
import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part 'create_tag.dart';

part 'create_test_tag.dart';

part 'list_tags.dart';

part 'get_tag_by_id.dart';







class TagsConnector {
  
  
  CreateTagVariablesBuilder createTag ({required double latitude, required double longitude, required String title, }) {
    return CreateTagVariablesBuilder(dataConnect, latitude: latitude,longitude: longitude,title: title,);
  }
  
  
  CreateTestTagVariablesBuilder createTestTag () {
    return CreateTestTagVariablesBuilder(dataConnect, );
  }
  
  
  ListTagsVariablesBuilder listTags () {
    return ListTagsVariablesBuilder(dataConnect, );
  }
  
  
  GetTagByIdVariablesBuilder getTagById ({required GetTagByIdVariablesKey key, }) {
    return GetTagByIdVariablesBuilder(dataConnect, key: key,);
  }
  

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'tags',
    'nfc-scavenger-hunt-service',
  );

  TagsConnector({required this.dataConnect});
  static TagsConnector get instance {
    
    CacheSettings cacheSettings = CacheSettings(
      maxAge: Duration(milliseconds:0),
      storage: CacheStorage.persistent,
    );
    
    return TagsConnector(
        dataConnect: FirebaseDataConnect.instanceFor(
            connectorConfig: connectorConfig,
            
            cacheSettings: cacheSettings,
            
            sdkType: CallerSDKType.generated));
  }

  FirebaseDataConnect dataConnect;
}

# dataconnect_generated SDK

## Installation
```sh
flutter pub get firebase_data_connect
flutterfire configure
```
For more information, see [Flutter for Firebase installation documentation](https://firebase.google.com/docs/data-connect/flutter-sdk#use-core).

## Data Connect instance
Each connector creates a static class, with an instance of the `DataConnect` class that can be used to connect to your Data Connect backend and call operations.

### Connecting to the emulator

```dart
String host = 'localhost'; // or your host name
int port = 9399; // or your port number
TagsConnector.instance.dataConnect.useDataConnectEmulator(host, port);
```

You can also call queries and mutations by using the connector class.
## Queries

### ListTags
#### Required Arguments
```dart
// No required arguments
TagsConnector.instance.listTags().execute();
```



#### Return Type
`execute()` returns a `QueryResult<ListTagsData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await TagsConnector.instance.listTags();
ListTagsData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = TagsConnector.instance.listTags().ref();
ref.execute();

ref.subscribe(...);
```


### GetTagById
#### Required Arguments
```dart
GetTagByIdVariablesKey key = ...;
TagsConnector.instance.getTagById(
  key: key,
).execute();
```



#### Return Type
`execute()` returns a `QueryResult<GetTagByIdData, GetTagByIdVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

/// Result of a query request. Created to hold extra variables in the future.
class QueryResult<Data, Variables> extends OperationResult<Data, Variables> {
  QueryResult(super.dataConnect, super.data, super.ref);
}

final result = await TagsConnector.instance.getTagById(
  key: key,
);
GetTagByIdData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
GetTagByIdVariablesKey key = ...;

final ref = TagsConnector.instance.getTagById(
  key: key,
).ref();
ref.execute();

ref.subscribe(...);
```

## Mutations

### CreateTag
#### Required Arguments
```dart
double latitude = ...;
double longitude = ...;
String title = ...;
TagsConnector.instance.createTag(
  latitude: latitude,
  longitude: longitude,
  title: title,
).execute();
```

#### Optional Arguments
We return a builder for each query. For CreateTag, we created `CreateTagBuilder`. For queries and mutations with optional parameters, we return a builder class.
The builder pattern allows Data Connect to distinguish between fields that haven't been set and fields that have been set to null. A field can be set by calling its respective setter method like below:
```dart
class CreateTagVariablesBuilder {
  ...
   CreateTagVariablesBuilder description(String? t) {
   _description.value = t;
   return this;
  }

  ...
}
TagsConnector.instance.createTag(
  latitude: latitude,
  longitude: longitude,
  title: title,
)
.description(description)
.execute();
```

#### Return Type
`execute()` returns a `OperationResult<CreateTagData, CreateTagVariables>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await TagsConnector.instance.createTag(
  latitude: latitude,
  longitude: longitude,
  title: title,
);
CreateTagData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
double latitude = ...;
double longitude = ...;
String title = ...;

final ref = TagsConnector.instance.createTag(
  latitude: latitude,
  longitude: longitude,
  title: title,
).ref();
ref.execute();
```


### CreateTestTag
#### Required Arguments
```dart
// No required arguments
TagsConnector.instance.createTestTag().execute();
```



#### Return Type
`execute()` returns a `OperationResult<CreateTestTagData, void>`
```dart
/// Result of an Operation Request (query/mutation).
class OperationResult<Data, Variables> {
  OperationResult(this.dataConnect, this.data, this.ref);
  Data data;
  OperationRef<Data, Variables> ref;
  FirebaseDataConnect dataConnect;
}

final result = await TagsConnector.instance.createTestTag();
CreateTestTagData data = result.data;
final ref = result.ref;
```

#### Getting the Ref
Each builder returns an `execute` function, which is a helper function that creates a `Ref` object, and executes the underlying operation.
An example of how to use the `Ref` object is shown below:
```dart
final ref = TagsConnector.instance.createTestTag().ref();
ref.execute();
```


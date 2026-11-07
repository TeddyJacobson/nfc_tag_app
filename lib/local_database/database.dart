import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import '/dataconnect_generated/generated.dart';

import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class TagTable extends Table {
  TextColumn get id => text()();
  RealColumn get latitude => real()();
  RealColumn get longitude => real()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}

@DriftDatabase(tables: [TagTable])
class AppDatabase extends _$AppDatabase {
  // After generating code, this class needs to define a `schemaVersion` getter
  // and a constructor telling drift where the database should be stored.
  // These are described in the getting started guide: https://drift.simonbinder.eu/setup/
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  // Insert tag entry into the table if it does not exist
  Future<int> insertTag(GetTagByIdTag tag) async {
    // Getting the correct description value if null
    Value<String?> description = tag.description != null
        ? Value(tag.description)
        : Value.absent();

    // Converting a tag into a entry companion
    TagTableCompanion tagTableEntry = TagTableCompanion(
      id: Value(tag.id),
      latitude: Value(tag.latitude),
      longitude: Value(tag.longitude),
      title: Value(tag.title),
      description: description,
    );

    // Searching if an entry with the same value already exists
    // Note, we must get a list, because getSingle() throws exception if entry DNE
    List<TagTableData> checkEntry = await (select(
      tagTable,
    )..where((tag) => tag.id.equals(tagTableEntry.id.value))).get();

    // No entry exists, so insert an entry
    if (checkEntry.isEmpty) {
      return into(tagTable).insert(tagTableEntry);
    }
    // An entry does exist, so do nothing
    return 0;
  }

  //TODO: Remove this function as it just for testing
  void printCurrentList() async {
    List<TagTableData> allItems = await select(tagTable).get();
    print('\n\n************** ITEMS IN DATABASE: $allItems\n\n');
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
        databaseDirectory: getApplicationDocumentsDirectory,
      ),
      // If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}

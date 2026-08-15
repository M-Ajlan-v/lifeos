import 'package:drift/drift.dart';
import 'package:lifeos/database/tables/users_table.dart';

class Features extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId => integer().references(Users, #id)();
  TextColumn get featureKey => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  IntColumn get parentFeatureId => integer().nullable().references(Features, #id)();
  IntColumn get isEnabled => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, featureKey},
  ];
}
import 'package:isar_community/isar.dart';

part 'room_cache.g.dart';

// The database representation of a Room, kept separate from the domain
// Room class so Isar's requirements (@collection, an Id field, late fields)
// don't leak into the rest of the app. The repository converts between them.
@collection
class RoomCache {
  Id id = Isar.autoIncrement;
  late String name;
  late int capacity;
  late String floor;
  // Isar 3.x has no native enum support, so RoomType is stored as its enum
  // member name ('boardroom', 'trainingRoom', 'focusPod') and converted
  // back to RoomType when reading.
  late String typeName;
  late bool isAvailable;
}

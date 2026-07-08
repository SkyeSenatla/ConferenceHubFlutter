// Pure Dart data model -- no Flutter import here.
// Data models should not depend on UI frameworks so they stay easy to
// test, reuse, and reason about.

// Assignment 1.1 stretch goal: a closed set of room types instead of a
// free-form String. This makes typos like 'Bordroom' a compile-time error
// instead of a silent runtime bug (see ASSIGNMENT.md Part A, Q1).
enum RoomType { boardroom, trainingRoom, focusPod }

// RoomType has no built-in human-readable label, so this extension maps
// each enum value to the text we actually want to show in the UI.
extension RoomTypeLabel on RoomType {
  String get displayName {
    switch (this) {
      case RoomType.boardroom:
        return 'Boardroom';
      case RoomType.trainingRoom:
        return 'Training';
      case RoomType.focusPod:
        return 'Focus Pod';
    }
  }
}

class Room {
  final String name;
  final int capacity;
  final String floor;
  final RoomType type;
  final bool isAvailable;

  // Default constructor. Marked `const` so Dart can build Room instances
  // at compile time when every argument is itself a compile-time constant.
  const Room({
    required this.name,
    required this.capacity,
    required this.floor,
    required this.type,
    this.isAvailable = true,
  });

  // Named constructor -- a factory for the "under maintenance" variation of
  // a Room, so callers don't need to remember to pass isAvailable: false.
  Room.underMaintenance({
    required String name,
    required int capacity,
    required String floor,
    required RoomType type,
  }) : this(
         name: name,
         capacity: capacity,
         floor: floor,
         type: type,
         isAvailable: false,
       );

  // A room can fit a group only if it is free and big enough.
  bool canFit(int headcount) => isAvailable && capacity >= headcount;

  @override
  String toString() {
    return '$name (${type.displayName}) -- $floor | Seats $capacity | '
        '${isAvailable ? "Free" : "Unavailable"}';
  }

  // NOTE: this is deliberately a separate method, not an overridden
  // toString(int headcount). Object.toString() is always called with zero
  // arguments by string interpolation, print(), debugPrint(), and the
  // debugger -- Dart won't let an override add a *required* parameter, and
  // an *optional* one would be silently ignored by all of those implicit
  // callers anyway. See ASSIGNMENT.md Part A, Q5.
  String describeFit(int headcount) {
    final fits = canFit(headcount);
    final fitDescription = fits
        ? 'Fits $headcount people'
        : 'Cannot fit $headcount people';
    return '${toString()} | $fitDescription';
  }
}

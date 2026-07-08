// Unit tests for the pure-Dart Room model -- no widgets involved, so these
// run instantly and don't need a Flutter environment to render anything.

import 'package:flutter_test/flutter_test.dart';
import 'package:conferencebookingsystemflutter/models/room.dart';

void main() {
  group('Room.canFit', () {
    test('returns true when available and big enough', () {
      const room = Room(
        name: 'Boardroom A',
        capacity: 12,
        floor: 'Floor 3',
        type: RoomType.boardroom,
      );
      expect(room.canFit(8), isTrue);
      expect(room.canFit(12), isTrue); // exact capacity counts as fitting
    });

    test('returns false when the headcount is too large', () {
      const room = Room(
        name: 'Focus Pod 1',
        capacity: 2,
        floor: 'Floor 2',
        type: RoomType.focusPod,
      );
      expect(room.canFit(3), isFalse);
    });

    test('returns false when the room is under maintenance', () {
      final room = Room.underMaintenance(
        name: 'Focus Pod 3',
        capacity: 2,
        floor: 'Floor 2',
        type: RoomType.focusPod,
      );
      // Big enough on paper, but unavailable, so it still cannot be booked.
      expect(room.canFit(1), isFalse);
      expect(room.isAvailable, isFalse);
    });
  });

  group('RoomType.displayName', () {
    test('maps every enum value to a human-readable label', () {
      expect(RoomType.boardroom.displayName, 'Boardroom');
      expect(RoomType.trainingRoom.displayName, 'Training');
      expect(RoomType.focusPod.displayName, 'Focus Pod');
    });
  });

  group('Room.describeFit', () {
    test('reports a fitting headcount without changing toString()', () {
      const room = Room(
        name: 'Boardroom B',
        capacity: 10,
        floor: 'Floor 3',
        type: RoomType.boardroom,
      );
      expect(room.toString(), contains('Free'));
      expect(room.describeFit(10), contains('Fits 10 people'));
    });

    test('reports an unavailable room as unable to fit anyone', () {
      final room = Room.underMaintenance(
        name: 'Focus Pod 3',
        capacity: 2,
        floor: 'Floor 2',
        type: RoomType.focusPod,
      );
      final description = room.describeFit(1);
      expect(description, contains('Unavailable'));
      expect(description, contains('Cannot fit 1 people'));
    });
  });
}

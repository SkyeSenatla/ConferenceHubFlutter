import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:conferencebookingsystemflutter/data/api_result.dart';
import 'package:conferencebookingsystemflutter/data/bookings_repository.dart';
import 'package:conferencebookingsystemflutter/models/booking.dart';
import 'package:conferencebookingsystemflutter/models/room.dart';
import 'package:conferencebookingsystemflutter/providers/bookings_notifier.dart';

class MockBookingsRepository extends Mock implements BookingsRepository {}

const _testRoom = Room(
  name: 'Boardroom A',
  capacity: 10,
  floor: '3',
  type: RoomType.boardroom,
);

final _testBookings = [
  const Booking(
    id: '1',
    meetingTitle: 'Sprint Planning',
    room: _testRoom,
    startTime: '09:00',
    endTime: '10:00',
    organiserEmail: 'alice@test.com',
    requiredHeadcount: 5,
  ),
  const Booking(
    id: '2',
    meetingTitle: 'Product Review',
    room: _testRoom,
    startTime: '11:00',
    endTime: '12:00',
    organiserEmail: 'bob@test.com',
    requiredHeadcount: 8,
  ),
];

// Riverpod 3 auto-retries a provider whose build() throws, with exponential
// backoff (200ms, 400ms, 800ms, ...), by default and indefinitely. That is
// the opposite of what these tests need: they deliberately want the notifier
// to sit in AsyncError until something (a test, or the "Try again" button in
// the real app) explicitly calls refresh(). Without disabling retry here,
// getBookings() gets called repeatedly in the background and container.read
// (bookingsProvider.future) never settles within the test's timeout -- it
// just hangs. `retry: (retryCount, error) => null` disables it for this
// container only.
ProviderContainer _buildContainer(MockBookingsRepository mockRepo) {
  final container = ProviderContainer(
    overrides: [bookingsRepositoryProvider.overrideWith((ref) => mockRepo)],
    retry: (retryCount, error) => null,
  );
  // bookingsProvider is @riverpod (autoDispose by default). A bare
  // container.read() doesn't hold a subscription open, so riverpod can
  // dispose the provider mid-flight -- before the awaited future settles --
  // producing "was disposed during loading state" instead of the actual
  // Success/Failure outcome. A no-op listener keeps it alive for the
  // container's lifetime, the same way a widget's ref.watch would in the
  // real app.
  container.listen(bookingsProvider, (_, _) {});
  return container;
}

void main() {
  late MockBookingsRepository mockRepo;

  setUp(() {
    mockRepo = MockBookingsRepository();
  });

  group('BookingsNotifier', () {
    test('transitions from loading to data when getBookings succeeds', () async {
      when(
        () => mockRepo.getBookings(),
      ).thenAnswer((_) async => Success(_testBookings));

      final container = _buildContainer(mockRepo);
      addTearDown(container.dispose);

      // Immediately after container creation the provider is loading.
      expect(container.read(bookingsProvider), isA<AsyncLoading>());

      // Await the underlying future -- this drives the async build() to completion.
      await container.read(bookingsProvider.future);

      expect(container.read(bookingsProvider).value, equals(_testBookings));
      verify(() => mockRepo.getBookings()).called(1);
    });

    test(
      'transitions from loading to error when getBookings returns Failure',
      () async {
        when(
          () => mockRepo.getBookings(),
        ).thenAnswer((_) async => const Failure('Network error'));

        final container = _buildContainer(mockRepo);
        addTearDown(container.dispose);

        expect(container.read(bookingsProvider), isA<AsyncLoading>());

        // The notifier re-throws Failure as Exception -- the future rejects.
        await expectLater(
          container.read(bookingsProvider.future),
          throwsA(isA<Exception>()),
        );

        expect(container.read(bookingsProvider), isA<AsyncError>());
        verify(() => mockRepo.getBookings()).called(1);
      },
    );

    test('recovers to data after refresh() following an error', () async {
      var callCount = 0;
      when(() => mockRepo.getBookings()).thenAnswer((_) async {
        callCount++;
        if (callCount == 1) return const Failure('Temporary outage');
        return Success(_testBookings);
      });

      final container = _buildContainer(mockRepo);
      addTearDown(container.dispose);

      // First build fails.
      await expectLater(
        container.read(bookingsProvider.future),
        throwsA(isA<Exception>()),
      );
      expect(container.read(bookingsProvider), isA<AsyncError>());

      // refresh() invalidates and awaits the new build -- second call succeeds.
      await container.read(bookingsProvider.notifier).refresh();
      expect(container.read(bookingsProvider).value, equals(_testBookings));

      verify(() => mockRepo.getBookings()).called(2);
    });
  });
}

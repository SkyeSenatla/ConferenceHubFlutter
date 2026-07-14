// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookings_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(BookingsNotifier)
final bookingsProvider = BookingsNotifierProvider._();

final class BookingsNotifierProvider
    extends $AsyncNotifierProvider<BookingsNotifier, List<Booking>> {
  BookingsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookingsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookingsNotifierHash();

  @$internal
  @override
  BookingsNotifier create() => BookingsNotifier();
}

String _$bookingsNotifierHash() => r'b798594468c04215c356a55589b1254ab8b14022';

abstract class _$BookingsNotifier extends $AsyncNotifier<List<Booking>> {
  FutureOr<List<Booking>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Booking>>, List<Booking>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Booking>>, List<Booking>>,
              AsyncValue<List<Booking>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

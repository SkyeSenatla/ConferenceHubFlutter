// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rooms_filter_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(RoomsFilterNotifier)
final roomsFilterProvider = RoomsFilterNotifierProvider._();

final class RoomsFilterNotifierProvider
    extends $NotifierProvider<RoomsFilterNotifier, bool> {
  RoomsFilterNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'roomsFilterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$roomsFilterNotifierHash();

  @$internal
  @override
  RoomsFilterNotifier create() => RoomsFilterNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$roomsFilterNotifierHash() =>
    r'6c2a60ea95737713c9c583ab4b187d6ace9ee07f';

abstract class _$RoomsFilterNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

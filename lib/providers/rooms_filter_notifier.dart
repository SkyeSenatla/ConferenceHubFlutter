import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../core/prefs_provider.dart';

part 'rooms_filter_notifier.g.dart';

@riverpod
class RoomsFilterNotifier extends _$RoomsFilterNotifier {
  static const _key = 'show_available_only';

  @override
  bool build() {
    return ref.watch(prefsProvider).getBool(_key) ?? false;
  }

  void toggle() {
    final next = !state;
    ref.read(prefsProvider).setBool(_key, next);
    state = next;
  }
}

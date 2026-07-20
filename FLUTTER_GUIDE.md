# Reading ConferenceHub as a C# Developer

*A file-by-file tour of the ConferenceBookingSystemFlutter app, written for someone who already thinks fluently in C#/OOP and needs the Dart/Flutter/Riverpod vocabulary mapped onto that existing mental model rather than taught from zero.*

**Layer key used throughout:** `[Model]` `[Data]` `[State]` `[UI]` `[Router]`

---

## 1. The big picture

Your app is five thin layers stacked on top of each other. Each layer only knows about the one directly below it — the same layering discipline you already use in a C# API project (controller → service → repository → DbContext).

```
lib/
├── models/          # Room, Booking — pure Dart, zero Flutter imports
├── data/            # api_result, booking_dto, bookings_repository — talks to the API
├── providers/       # bookings_notifier, bookings_provider — Riverpod state
├── screens/         # full-page widgets: BookingsScreen, BookingDetailScreen
├── widgets/         # reusable pieces: RoomBookingCard, RoomStatusBadge
└── router/          # app_router — URL → screen mapping
```

Map that onto ASP.NET Core and it reads almost directly:

| ASP.NET Core API (your other project) | ConferenceHub (Flutter) |
|---|---|
| Entity / EF model | `[Model]` `Room`, `Booking` |
| Response DTO | `[Data]` `BookingDto` |
| Repository / DbContext | `[Data]` `BookingsRepository` (Dio calls) |
| Service layer (business rules) | `[State]` `BookingsNotifier`, derived providers |
| Controller (HTTP → JSON) | `[UI]` Screens + widgets (the "controller" is gone — the widget *is* the render step) |

The one genuinely new concept is the `[Router]` layer: in a web API, routing maps a URL to a controller action on the server. Here, `go_router` maps a URL (`/bookings/3`) to a *screen widget*, entirely on the device, with no server round-trip involved in the navigation itself.

> This app is also a live course exercise — `ASSIGNMENT.md` at the project root records the reasoning behind several design decisions (enum vs string, field vs computed getter, why `const` matters). It's worth reading alongside this guide; it's the "why" behind choices this guide explains as "what."

---

## 2. Dart, for someone who knows C#

Dart and C# are close cousins — both are statically-typed, null-safe, OOP-first languages with async/await. The differences that'll trip you up are small and specific, not conceptual.

| Concept | C# | Dart (as used in this repo) |
|---|---|---|
| Null safety | `string?`, mostly warnings | `String?`, enforced at compile time — non-nullable is the default and unescapable |
| Immutable data | `record Room(string Name, ...)` | `@freezed class Room` — does the same job via codegen (§8) |
| Discriminated union + exhaustive switch | `sealed record` hierarchy + `switch` pattern matching (C# 8+) | `sealed class ApiResult<T>` + `switch` expression (§5) |
| Extension methods | `static class Ext { public static string DisplayName(this RoomType t) }` | `extension RoomTypeLabel on RoomType { String get displayName }` — same idea, different syntax |
| Static factory method | `public static Room UnderMaintenance(...)` | `factory` constructors, plus Dart's **named constructors** (`Room.underMaintenance(...)`) — a language feature C# doesn't have at all |
| Compile-time constants | `static readonly` (still allocated once, at runtime) | `const Room(...)` — genuinely built at compile time and canonicalized; identical `const` calls share one instance |
| Top-level members | Not allowed — everything lives in a class | Functions and variables can live directly in a file, no wrapping class required |
| Async | `async`/`await`, `Task<T>` | `async`/`await`, `Future<T>` — near 1:1 |

Two of these are worth seeing in the actual repo. First, the named record in `bookings_repository.dart` — Dart's answer to a C# tuple, but with named fields baked into the type itself, no class declaration required:

```dart
// A named record: bundles two parsed lists into one lightweight,
// type-safe return value with no class declaration needed.
({List<BookingDto> bookings, List<Room> rooms}) _parseResponses(
  List<Response<dynamic>> results,
) {
  return (
    bookings: /* ... */,
    rooms: /* ... */,
  );
}

// caller destructures it exactly like a C# tuple deconstruction:
final (:bookings, :rooms) = _parseResponses(responses);
```

Second, the named constructor on `Room` — notice it isn't `static`, and it isn't a separate factory function; it's a second, differently-named entry point into constructing the *same* type:

```dart
const Room({required this.name, required this.capacity, /* ... */, this.isAvailable = true});

// Named constructor -- a factory for the "under maintenance" variation of
// a Room, so callers don't need to remember to pass isAvailable: false.
Room.underMaintenance({required String name, /* ... */})
    : this(name: name, /* ... */, isAvailable: false);

// called as:
Room.underMaintenance(name: 'Focus Pod 3', capacity: 2, floor: 'Floor 2', type: RoomType.focusPod);
```

---

## 3. Flutter's mental model

This is the biggest conceptual jump from a WPF/WinForms/MVVM background, so it's worth being explicit: Flutter has no mutable "controls" that you push new values into. It *re-runs a function that describes the entire UI*, every time relevant data changes.

**WPF / WinForms (imperative, retained-mode)** — You build a tree of controls once. To show new data, you reach back into that tree and mutate a property: `label.Text = newValue;`. The tree is long-lived; you poke it.

**Flutter (declarative, rebuild-on-change)** — Every widget has a `build(BuildContext)` method that returns a description of what the UI should look like *right now*, given current data. When data changes, Flutter calls `build()` again and diffs the result against what's on screen. You never mutate a rendered control directly.

Concretely, every widget in this app is one of two kinds:

- **`StatelessWidget`** — a pure function of its constructor arguments. `RoomBookingCard`, `RoomStatusBadge`, `RoomsPlaceholderScreen` are all this. If you've written a stateless React or Blazor component, this is the same contract: given the same inputs, it always renders the same output, and it holds no memory of its own between renders.
- **`ConsumerWidget`** — a `StatelessWidget` with one added parameter, `WidgetRef ref`, that lets `build()` reach into Riverpod's container. `BookingsScreen` and `BookingDetailScreen` are both this — see §4.

Notably absent from this app: `StatefulWidget`, the one you'd reach for if a widget needed to remember something itself (an animation controller, a text field's current draft text) rather than deriving everything from providers. Every piece of state that outlives a single `build()` call here — the filter selection, the fetched bookings — is pushed out into Riverpod instead. That's a deliberate, idiomatic choice: keep widgets dumb, keep state in providers.

`BuildContext context`, the parameter every `build()` receives, is the closest thing here to an ambient service locator: it's how a widget reaches *up* the tree for things like the current theme (`Theme.of(context)`) or the router (`context.push(...)`), without those being threaded through every constructor by hand.

---

## 4. Riverpod: DI and state, unified

If you mentally split "dependency injection container" and "observable state / `INotifyPropertyChanged`" into two separate concerns in C#, Riverpod's whole pitch is that they're the same problem: both are "some value, computed from other values, that consumers should be notified about when it changes."

**ASP.NET Core**
- `builder.Services.AddScoped<IFoo, Foo>()` — register once
- Constructor injection resolves it where needed
- State changes require manual `INotifyPropertyChanged` plumbing

**Riverpod**
- `@riverpod Dio dio(Ref ref) { ... }` — declare once
- `ref.watch(dioProvider)` resolves it where needed
- Watching *is* subscribing — no extra plumbing

`ProviderScope` in `main.dart` is the composition root — the one place a "container" is created for the whole app, analogous to the `ServiceProvider` that `WebApplicationBuilder` builds under the hood:

```dart
void main() {
  runApp(const ProviderScope(child: ConferenceHubApp()));
}
```

Every `@riverpod`-annotated top-level function or class becomes a provider, and the code generator writes the wiring (see §8). This repo has three flavors, and the distinction between them maps onto three different C# scenarios:

| Provider | Declared as | Closest C# analogue |
|---|---|---|
| `dioProvider` | plain `@riverpod` function returning `Dio` | a singleton service registration — built once, reused everywhere |
| `bookingsNotifierProvider` | `@riverpod class BookingsNotifier extends _$BookingsNotifier` with an async `build()` | a view-model with an async constructor/initializer, whose result is wrapped in a loading/error/data union (see below) |
| `selectedFilterProvider` | `StateProvider<String>` | a simple observable/mutable field — closest to a `BehaviorSubject<string>` |

```dart
@riverpod
class BookingsNotifier extends _$BookingsNotifier {
  @override
  Future<List<Booking>> build() async {
    final result = await ref.read(bookingsRepositoryProvider).getBookings();
    return switch (result) {
      Success(:final data) => data,
      Failure(:final message) => throw Exception(message),
    };
  }

  Future<void> refresh() async {
    ref.invalidateSelf();  // discard cached state...
    await future;           // ...and wait for build() to run again
  }
}
```

Because `build()` is `async` and returns `Future<List<Booking>>`, Riverpod automatically exposes this to widgets as `AsyncValue<List<Booking>>` — a three-state union (`loading` / `error` / `data`) that widgets pattern-match on with `.when(...)`. Think of it as `Task<T>` fused with a `Result<T, Error>`, plus a mandated exhaustive switch at the point of use — you can't accidentally forget to handle the error case, the way you might forget a `catch` block in C#:

```dart
asyncBookings.when(
  loading: () => const CircularProgressIndicator(),
  error: (error, stack) => /* retry button */,
  data: (bookings) => /* the actual list */,
);
```

The last piece is `ref.watch` vs `ref.read`, and getting this wrong is the single most common Riverpod bug:

- `ref.watch(x)` — **subscribes**. Use it inside `build()`. If `x` changes later, this widget rebuilds automatically.
- `ref.read(x)` — **one-off resolve**, no subscription. Use it inside callbacks (button handlers) where you want the current value once, not a standing subscription that would leak or double-fire.

You can see both in the same screen — `watch` to render the currently selected chip, `read` inside the tap handler to write a new selection without subscribing the handler itself to anything:

```dart
final selectedFilter = ref.watch(selectedFilterProvider);          // subscribe, for rendering
// ...
onSelected: (_) {
  ref.read(selectedFilterProvider.notifier).state = option;         // one-time write
},
```

And `filteredBookingsProvider` shows the "computed property" side of Riverpod — a provider that derives its value by watching *two others*, recalculating whenever either changes, the way a LINQ query recomputes if you re-ran it against fresh data — except here it re-runs itself, reactively:

```dart
final filteredBookingsProvider = Provider<AsyncValue<List<Booking>>>((ref) {
  final asyncBookings = ref.watch(bookingsNotifierProvider);  // dependency 1
  final filter = ref.watch(selectedFilterProvider);           // dependency 2
  return asyncBookings.whenData((bookings) {
    if (filter == 'All') return bookings;
    return bookings.where((b) => b.room.type.displayName == filter).toList();
  });
});
```

---

## 5. The data layer: Dio, DTOs, ApiResult

This is where the Flutter app talks to *your own* C# API — the same one running under `ConferenceBookingAPI`. Three files cooperate here, each with one job.

### `[Data]` ApiResult — a typed alternative to exceptions

`sealed class ApiResult<T>` is a two-case discriminated union, exactly like a `sealed record` hierarchy in C# 8+. The payoff is the same in both languages: the compiler proves every `switch` handles both branches, so a caller literally cannot forget to handle failure — contrast with a thrown exception, which a caller can silently fail to catch.

```dart
sealed class ApiResult<T> {
  const ApiResult();
}
class Success<T> extends ApiResult<T> {
  final T data;
  const Success(this.data);
}
class Failure<T> extends ApiResult<T> {
  final String message;
  final int? statusCode;
  const Failure(this.message, {this.statusCode});
}
```

### `[Data]` BookingDto — the wire shape, deliberately separate from the UI model

This is a direct mirror of your C# response DTO. Put them side by side:

**`API.DTOs.BookingResponse` (C#)**
```csharp
public record BookingResponse(
    Guid Id, string Title, string Type,
    string RoomName, string Floor,
    DateTime StartTime, DateTime EndTime,
    string OrganizerEmail, int AttendeeCount,
    List<string> ExternalAttendees
);
```

**`BookingDto` (Dart)**
```dart
@freezed
class BookingDto with _$BookingDto {
  const factory BookingDto({
    required String id, required String title,
    required String type, required String roomName,
    required String floor, required DateTime startTime,
    required DateTime endTime, required String organizerEmail,
    required int attendeeCount,
  }) = _BookingDto;
}
```

Notice `ExternalAttendees` didn't make the trip — the Dart DTO only declares the fields this app actually renders. That's the point of having a separate DTO at all: if the C# API adds a field tomorrow, nothing here breaks; if it removes a field this app *does* use, `BookingDto.fromJson` fails loudly and immediately, in one file, instead of a null creeping silently into a chip somewhere in the UI.

It's also why there's a *second* model, `Booking` (in `models/`, not `data/`) — the DTO is the API's shape; `Booking` is the shape the UI actually wants (e.g. pre-formatted `"09:00"` strings instead of raw `DateTime`, and a resolved `Room` object instead of a bare room name). `Booking.fromDto(...)` is the translation step, and it's the *only* place that translation happens.

### `[Data]` BookingsRepository — the Dio-backed gateway

This is your `HttpClient`-wrapping repository class, one-to-one. A couple of details worth flagging as intentional rather than accidental:

```dart
Future<ApiResult<List<Booking>>> getBookings() async {
  try {
    // Fetch bookings and rooms in parallel -- one network round trip, not two.
    final responses = await Future.wait([
      _dio.get<dynamic>('/api/bookings'),
      _dio.get<dynamic>('/api/rooms'),
    ]);
    // ...parse, join by room name, return Success(...)
  } on DioException catch (e) {
    return Failure(_messageFromDioError(e), statusCode: e.response?.statusCode);
  } catch (_) {
    return Failure('An unexpected error occurred.');
  }
}
```

- `Future.wait([...])` is Dart's `Task.WhenAll` — both endpoints fire concurrently, not sequentially.
- The `try`/`catch` is the one and only place a raw exception is allowed to exist in this data flow — everywhere past this method, callers only ever see `ApiResult`.
- The file imports `package:riverpod/riverpod.dart`, **not** `flutter_riverpod` — a deliberate boundary. This file has no business depending on Flutter/UI at all (that's what makes `tool/verify_live_api.dart`, a plain `dart run` script with no Flutter engine attached, able to exercise it directly).

---

## 6. Domain models: Room and Booking

These live in `models/`, contain zero Flutter imports, and are tested with plain `flutter_test` unit tests that never touch a widget — the Dart equivalent of a domain-model unit test that never spins up a web host.

`Room` is worth reading in full — it's a compact tour of several C#-familiar-but-differently-spelled Dart features at once: enums with an extension for display text, a default constructor plus a named constructor, and a method deliberately kept separate from `toString()`:

```dart
enum RoomType { boardroom, trainingRoom, focusPod }

extension RoomTypeLabel on RoomType {
  String get displayName => switch (this) {
    RoomType.boardroom => 'Boardroom',
    RoomType.trainingRoom => 'Training',
    RoomType.focusPod => 'Focus Pod',
  };
}

class Room {
  final String name;
  final int capacity;
  final String floor;
  final RoomType type;
  final bool isAvailable;

  const Room({required this.name, required this.capacity, required this.floor,
              required this.type, this.isAvailable = true});

  bool canFit(int headcount) => isAvailable && capacity >= headcount;
}
```

> **Why `canFit` exists at all:** it's a small OOP discipline worth naming explicitly — the rule "a room fits a group only if it's free *and* big enough" lives in exactly one place, on the type that owns the data. Every screen that needs that answer calls `room.canFit(n)` rather than re-deriving the same boolean expression inline. Same instinct as keeping a business rule inside a C# entity/service rather than scattering it across controllers.

`Booking` is a `@freezed` class (see §8) with one method worth noting, `Booking.fromDto` — the single seam between the API's shape (`BookingDto`, raw `DateTime`) and the UI's shape (`Booking`, pre-formatted `"HH:mm"` strings):

```dart
static Booking fromDto(BookingDto dto, Room room) {
  return Booking(
    id: dto.id, meetingTitle: dto.title, room: room,
    startTime: _formatTime(dto.startTime), endTime: _formatTime(dto.endTime),
    organiserEmail: dto.organizerEmail, requiredHeadcount: dto.attendeeCount,
  );
}
```

---

## 7. Routing: go_router's shell and branches

`go_router` is declarative client-side routing — URLs map to screen widgets the same way an ASP.NET Core route table maps URLs to controller actions, except the "server" here is the app itself and there's no HTTP request involved in a tab switch.

```dart
final appRouter = GoRouter(
  initialLocation: '/bookings',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNavBar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/bookings', builder: (c, s) => const BookingsScreen(),
            routes: [
              GoRoute(path: ':id', builder: (c, s) {
                final id = s.pathParameters['id']!;
                return BookingDetailScreen(bookingId: id);
              }),
            ]),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/rooms', builder: (c, s) => const RoomsPlaceholderScreen()),
        ]),
      ],
    ),
  ],
);
```

The one piece with no direct C#-web analogue is `StatefulShellRoute.indexedStack`. It's the bottom navigation bar's plumbing: each branch (Bookings, Rooms) keeps its *own* independent navigation history. If you drill into a booking's detail screen, then switch to the Rooms tab and back, you land back on the detail screen — the Bookings branch didn't forget where you were. Think of it as each tab owning a separate back-stack, the way a mobile OS keeps a per-tab history rather than one global one.

Also notice: `state.pathParameters['id']` is always a `String` — there's no `int.parse` anywhere here, because the booking IDs are GUIDs coming straight from the C# API, and URL path segments are strings regardless.

---

## 8. Code generation, demystified

Every `part 'x.g.dart';` or `part 'x.freezed.dart';` line you've seen so far points at a *generated* file — the Dart analogue of a C# source generator (`System.Text.Json`'s source-gen mode is the closest comparison) rather than the reflection-based serialization you'd get from classic Newtonsoft.Json.

| Annotation | Package | Generates |
|---|---|---|
| `@freezed` | `freezed_annotation` | `copyWith`, value-based `==`/`hashCode`, a working `toString()` — the boilerplate a C# `record` gives you for free at the language level, but which Dart classes don't |
| `fromJson` factory + `@freezed` | `json_serializable` | `_$BookingDtoFromJson` — explicit, checked JSON parsing code (no runtime reflection) |
| `@riverpod` | `riverpod_annotation` | the actual `Provider`/`AsyncNotifierProvider` class and its `bookingsNotifierProvider`-style global instance |

The generation step itself is `build_runner`, invoked as `dart run build_runner build` (declared under `dev_dependencies` in `pubspec.yaml`). It scans the project for these annotations and writes the matching `.g.dart`/`.freezed.dart` files next to the source file that declared them. The `part`/`part of` pair is what stitches the generated file back into the *same* library as a single logical unit — unlike a C# partial class, which needs no such declaration because the compiler already treats same-named partials as one type by convention.

> Practical takeaway: if you ever change a `@freezed` class or a `@riverpod` function and the analyzer starts complaining about a missing `_$ClassName` or `classNameProvider`, that's not a bug — it means the generated file is stale. Re-run `dart run build_runner build --delete-conflicting-outputs`.

---

## 9. Testing strategy

Two distinct test styles live side by side here, and the split maps cleanly onto a distinction you already make in xUnit: pure unit tests against plain classes, vs. tests that need the full runtime spun up.

**`test/room_test.dart` — unit test.** Tests `Room.canFit`/`describeFit` directly. No widget, no Flutter engine, runs instantly. Equivalent to an xUnit test against a plain C# class with no ASP.NET Core host involved.

**`test/widget_test.dart` — widget test.** Pumps the actual `ConferenceHubApp` widget tree into a simulated Flutter binding and asserts on rendered text/widgets. Closer to an integration test through `WebApplicationFactory` — you're exercising real composed code, not a mock.

The interesting move in the widget test is how it avoids hitting the network at all — it doesn't mock `Dio`, it replaces the *whole notifier* via a Riverpod provider override, which is conceptually identical to substituting a service registration in an ASP.NET Core test host:

```dart
class _FakeBookingsNotifier extends BookingsNotifier {
  @override
  Future<List<Booking>> build() async {
    await Future.delayed(const Duration(milliseconds: 1500));
    return _fakeBookings;  // hardcoded dataset
  }
}

await tester.pumpWidget(
  ProviderScope(
    overrides: [
      bookingsNotifierProvider.overrideWith(_FakeBookingsNotifier.new),
    ],
    child: const ConferenceHubApp(),
  ),
);
```

Every screen widget still calls `ref.watch(bookingsNotifierProvider)` completely unaware anything was swapped — same principle as an ASP.NET Core test replacing `IBookingsRepository` in the DI container without the controller code knowing or caring.

`tool/verify_live_api.dart` is a third, informal category: a throwaway script (`dart run tool/verify_live_api.dart`) that hits the *real* running C# API to sanity-check the whole Dio → JSON → DTO → domain-model pipeline end to end. It's not part of the automated test suite — think of it as a scratch console app you'd write to manually poke an API before writing a proper test.

---

## 10. Trace: one tap, start to finish

Concepts click into place fastest when you follow one real user action through every layer. Here's what happens when someone opens the app, taps the **Boardroom** filter chip, then taps a booking card.

1. `[Router]` App launches. `go_router` resolves `initialLocation: '/bookings'` and builds `BookingsScreen` inside the shared `ScaffoldWithNavBar`.
2. `[UI]` `BookingsScreen.build()` calls `ref.watch(filteredBookingsProvider)` — first read, so Riverpod has to build the whole dependency chain.
3. `[State]` That pulls in `bookingsNotifierProvider`, whose `build()` calls `bookingsRepositoryProvider.getBookings()`.
4. `[Data]` `BookingsRepository` fires `GET /api/bookings` and `GET /api/rooms` at your C# API concurrently via Dio.
5. `[Data]` Responses parse into `BookingDto`/`Room`, get joined by room name, and convert into `Booking` objects via `Booking.fromDto`.
6. `[State]` `ApiResult` is unwrapped inside the notifier's `build()`; on success, Riverpod's `AsyncValue` transitions `loading → data`.
7. `[UI]` `BookingsScreen` rebuilds (only this widget — nothing else was subscribed) and renders the booking list.
8. `[UI]` User taps the **Boardroom** chip → `ref.read(selectedFilterProvider.notifier).state = 'Boardroom'`. No new subscription is created here — it's a one-time write.
9. `[State]` `filteredBookingsProvider` was watching `selectedFilterProvider`, so it recomputes automatically and filters the already-fetched list — **no new network call**.
10. `[UI]` User taps a booking card → `context.push('/bookings/${booking.id}')`, navigating by the booking's stable GUID, never its position in the (filterable, reorderable) list.
11. `[Router]` `go_router` matches the child route `:id` and builds `BookingDetailScreen(bookingId: id)`.
12. `[UI]` The detail screen deliberately watches the *raw* `bookingsNotifierProvider`, not the filtered one — otherwise a Focus Pod booking would vanish from view the moment the filter chip was set to "Boardroom."

---

## 11. Where to go next

The fastest way to internalize this is to change something small end-to-end and watch the compiler and codegen guide you through every layer that needs to move in lockstep.

- **Add a field.** Add `ExternalAttendees` (already in the C# `BookingResponse`, dropped in `BookingDto` — see §5) all the way through: `BookingDto` → run `build_runner` → `Booking` → `Booking.fromDto` → a new row in `BookingDetailScreen`. You'll feel exactly where the analyzer complains if you miss a step.
- **Inspect a generated file.** Open `bookings_notifier.g.dart` once, just to see the provider class riverpod_generator actually wrote from your `@riverpod` annotation — demystifies the "magic" immediately.
- **Write one more widget test.** Add a case to `widget_test.dart` that taps the "Training" filter chip and asserts only training-room bookings remain — you'll be exercising `ref.read`-inside-a-callback and a provider recompute directly.
- **Read `ASSIGNMENT.md` fully.** It's a worked example of exactly the kind of design reasoning ("why an enum, not a string," "why a field, not a computed getter") that's easy to skim past in code but is where the real design judgment lives.

---

*Generated as a reading companion to `C:\Users\Skye\Desktop\ConferenceBookingSystemFlutter`, cross-referenced against `API.DTOs.BookingResponse` in the sibling `ConferenceBookingAPI` project.*

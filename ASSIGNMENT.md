# Assignment 1.1

## Part A — Written Decisions

### 1. Room type choice

With `type` as a `String`, nothing stops two different call sites from writing
`'Boardroom'` and `'boardroom'` (or a typo like `'Bordroom'`). A filter such as
`rooms.where((r) => r.type == 'Boardroom')` would silently drop the
mistyped room instead of failing to compile — the bug only shows up when a
real user notices a room missing from a filtered list. I changed `type` to a
`RoomType` enum (`boardroom`, `trainingRoom`, `focusPod`). That forces every
comparison and switch to go through a closed, compiler-checked set of values,
and it means anywhere `type` was displayed as text (the `Chip` label in
`RoomBookingCard`) now needs an explicit enum → display-string mapping, which
I added as a `displayName` extension getter on `RoomType`.

### 2. isAvailable as a field vs a method

A `final bool` field is simple, fast, and immutable — appropriate when there
is no other data to derive it from. A getter computed from
`List<Booking>` (`isAvailable => !bookings.any((b) => b.overlaps(now))`) is
always in sync with the real schedule, but it requires the `Room` to have
access to booking data and a notion of "now", coupling a data model to
time and to another collection. For Day 1, the field is correct: there is no
booking list yet, and `Room.underMaintenance()` is a deliberate, static
condition (out of service), not a scheduling outcome. In Week 2, once real
bookings exist, a hardcoded field would drift from reality — a room could
stay marked "available" forever while actually fully booked — so
`isAvailable` will need to become a computed getter driven by the booking
list at that point.

### 3. const constructability

In the original lab code, each `Room(...)` inside `BookingsScreen` was
constructed without `const`, so even though `RoomBookingCard` has a `const`
constructor, none of its usages could be marked `const` — a widget can only
be `const` if every argument passed to it, including nested constructor
calls, is itself a compile-time constant. I fixed this by marking every
`Room(...)` call `const` (its own constructor was already `const`) and then
marking every `RoomBookingCard(...)` call `const` too. Because all of Day
1's booking data is hardcoded literals, this costs nothing and is worth
doing immediately — Flutter can cache these widget instances instead of
rebuilding them on every frame. This will stop being possible once bookings
come from an API in Week 2, since the data will then be a runtime value —
that's expected, not a regression.

### 4. Organiser as String

A `String organiser` only stores a display name. It loses everything else
you'd need to actually act on an organiser: a stable identity (so renaming
someone doesn't silently disconnect them from their past bookings), an email
address (to notify them about their meeting), and a department/team (to
answer questions like "how many rooms does Engineering book per week?").
An `Organiser` type would look like:

- `id` — a stable unique identifier (String), used for lookups and equality
- `name` — display name (String)
- `email` — contact address (String)
- `department` — team/business unit (String)

### 5. The problem with a headcount-aware toString()

`toString()` overrides `Object.toString()`, which Dart (and everything that
calls it implicitly — string interpolation like `'$room'`, `print(room)`,
`debugPrint`, exception messages, IDE debugger tooltips) always calls with
**zero arguments**. You cannot override it with a *required* parameter — the
analyzer rejects it as an invalid override, since all of those implicit call
sites have no headcount to pass. Even an *optional* parameter wouldn't
actually solve the requirement: every implicit caller would just get the
default value, so `toString()` could never really vary per headcount for the
callers that matter.

The fix I implemented: leave `toString()` alone (still zero-arg, still safe
for every implicit caller) and add a **separate** method,
`describeFit(int headcount)`, that composes on top of `toString()` to report
whether the room can fit a specific headcount. Call sites that need the
headcount-aware description call `describeFit(...)` explicitly instead of
relying on implicit `toString()` invocation.

## Part C — Proving It Changed

This environment has no Android/iOS emulator or display attached, so I
could not capture the screenshots/recording Part C asks for. Instead, the
same three behaviours are verified with automated tests, which I consider
stronger proof than a manual screenshot because they run on every future
change:

1. **Focus Pod card / Unavailable indicator** — `test/widget_test.dart`
   pumps `ConferenceHubApp` and asserts the `'Focus Time (1:1 Feedback)'`
   card is present and that the literal text `'Unavailable'` is rendered
   (the new conditional chip in `RoomBookingCard`, only shown when
   `!room.isAvailable`).
2. **canFit chips (green vs red)** — the same test asserts both
   `'Fits 8 people'` (green chip, Engineering Standup vs its
   `requiredHeadcount`) and `'Too small'` (red chip, New Hire Onboarding
   vs its `requiredHeadcount`) are present at the same time, proving both
   branches render correctly.
3. **Updated toString() / describeFit()** — `test/room_test.dart` unit-tests
   `Room.underMaintenance(...).describeFit(1)` directly and checks the
   returned string contains both `'Unavailable'` and `'Cannot fit 1
   people'`, without needing a running app at all.

Run `flutter test` to see all of the above pass.

## Checklist

- [x] Part A written responses completed before implementing Part B
- [x] All four booking cards render without errors (`flutter test`)
- [x] The canFit chips appear correctly (green when fits, red when too small)
- [x] `Room.underMaintenance` rooms show as unavailable in the UI
- [x] No `print` statements left in production code
- [x] Code formatted (`dart format .`)
- [ ] Committed to GitHub (do this yourself once you're happy with the diff)

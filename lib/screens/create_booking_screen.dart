import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../models/room.dart';
import '../providers/rooms_notifier.dart';

class CreateBookingScreen extends HookConsumerWidget {
  const CreateBookingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // useMemoized creates the key once and returns the same instance on every
    // rebuild. Without this, a new GlobalKey would be created each build(),
    // which destroys and recreates the entire FormBuilder state -- wiping
    // every field the user has filled in.
    final formKey = useMemoized(() => GlobalKey<FormBuilderState>());
    // riverpod 3 renamed AsyncValue.valueOrNull to .value.
    final rooms = ref.watch(roomsProvider).value ?? [];

    void submit() {
      if (formKey.currentState!.saveAndValidate()) {
        final values = formKey.currentState!.value;
        final title = values['title'] as String;
        // In a full implementation, pass values to the bookings repository here.
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Booking "$title" created!')));
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('New Booking'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FormBuilderTextField(
                name: 'title',
                decoration: const InputDecoration(
                  labelText: 'Meeting title',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(3),
                ]),
              ),
              const SizedBox(height: 16),
              FormBuilderDropdown<Room>(
                name: 'room',
                decoration: const InputDecoration(
                  labelText: 'Room',
                  border: OutlineInputBorder(),
                ),
                items: rooms
                    .map(
                      (room) => DropdownMenuItem(
                        value: room,
                        child: Text('${room.name} — ${room.capacity} seats'),
                      ),
                    )
                    .toList(),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: 'start_time',
                inputType: InputType.both,
                decoration: const InputDecoration(
                  labelText: 'Start time',
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 16),
              FormBuilderDateTimePicker(
                name: 'end_time',
                inputType: InputType.both,
                decoration: const InputDecoration(
                  labelText: 'End time',
                  border: OutlineInputBorder(),
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  (value) {
                    final start =
                        formKey.currentState?.fields['start_time']?.value
                            as DateTime?;
                    if (start == null || value == null) return null;
                    if (!value.isAfter(start)) {
                      return 'End time must be after start time';
                    }
                    return null;
                  },
                ]),
              ),
              const SizedBox(height: 16),
              FormBuilderTextField(
                name: 'attendee_count',
                decoration: const InputDecoration(
                  labelText: 'Number of attendees',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.integer(),
                  FormBuilderValidators.min(1),
                  (value) {
                    final room =
                        formKey.currentState?.fields['room']?.value as Room?;
                    if (room == null || value == null) return null;
                    final count = int.tryParse(value) ?? 0;
                    if (count > room.capacity) {
                      return 'Room only fits ${room.capacity} people';
                    }
                    return null;
                  },
                ]),
              ),
              const SizedBox(height: 24),
              FilledButton(onPressed: submit, child: const Text('Create booking')),
            ],
          ),
        ),
      ),
    );
  }
}

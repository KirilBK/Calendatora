import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/event_model.dart';
import '../services/auth_service.dart';
import '../services/event_service.dart';
import '../screens/event_form_screen.dart';

class EventList extends StatelessWidget {
  final List<CalendarEvent> events;
  final bool editable;

  const EventList({
    super.key,
    required this.events,
    required this.editable,
  });

  // Format event date and time
  String _formatEventTime(CalendarEvent event) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    final timeFormat = DateFormat('HH:mm');

    return '${dateFormat.format(event.startTime)} - '
        '${timeFormat.format(event.endTime)}';
  }

  // Handle event deletion with confirmation
  Future<void> _deleteEvent(
      BuildContext context, EventService service, CalendarEvent event) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Event'),
        content: const Text('Are you sure you want to delete this event?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      await service.deleteEvent(event.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final eventService = Provider.of<EventService>(context);

    if (events.isEmpty) {
      return const Center(
        child: Text(
          'No events',
          style: TextStyle(fontSize: 16),
        ),
      );
    }

    return ListView.builder(
      itemCount: events.length,
      padding: const EdgeInsets.all(8),
      itemBuilder: (context, i) {
        final event = events[i];
        final canEdit =
            editable && auth.user != null && event.createdBy == auth.user!.uid;

        return Card(
          elevation: 2,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: event.color != null
                  ? Color(int.parse(event.color!.replaceFirst('#', '0xff')))
                  : Colors.blue,
              child: const Icon(Icons.event, color: Colors.white),
            ),
            title: Text(
              event.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_formatEventTime(event)),
                if (event.description != null)
                  Text(
                    event.description!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
            trailing: canEdit
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EventFormScreen(event: event),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteEvent(
                          context,
                          eventService,
                          event,
                        ),
                      ),
                    ],
                  )
                : null,
          ),
        );
      },
    );
  }
}
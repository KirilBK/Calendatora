import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../services/event_service.dart';
import '../models/event_model.dart';
import 'event_list.dart';

class CalendarWidget extends StatefulWidget {
  const CalendarWidget({super.key});

  @override
  State<CalendarWidget> createState() => _CalendarWidgetState();
}

class _CalendarWidgetState extends State<CalendarWidget> {
  // Basic calendar state
  CalendarFormat _format = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  // Helper method to filter events for a specific day
  List<CalendarEvent> _getEventsForDay(List<CalendarEvent> events, DateTime day) {
    return events.where((event) =>
      event.startTime.year == day.year &&
      event.startTime.month == day.month &&
      event.startTime.day == day.day
    ).toList();
  }

  // Handle day selection
  void _onDaySelected(DateTime selected, DateTime focused) {
    setState(() {
      _selectedDay = selected;
      _focusedDay = focused;
    });
  }

  @override
  Widget build(BuildContext context) {
    final eventService = Provider.of<EventService>(context);
    final events = eventService.events;

    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2020, 1, 1),
          lastDay: DateTime.utc(2100, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _format,
          selectedDayPredicate: (day) => 
              isSameDay(_selectedDay, day),
          onDaySelected: _onDaySelected,
          onFormatChanged: (format) => 
              setState(() => _format = format),
          eventLoader: (day) => 
              _getEventsForDay(events, day),
          calendarStyle: const CalendarStyle(
            markersMaxCount: 3,
            todayDecoration: BoxDecoration(
              color: Colors.blue,
              shape: BoxShape.circle,
            ),
            selectedDecoration: BoxDecoration(
              color: Colors.deepPurple,
              shape: BoxShape.circle,
            ),
          ),
        ),
        if (eventService.isLoading)
          const Center(child: CircularProgressIndicator())
        else
          Expanded(
            child: EventList(
              events: _getEventsForDay(
                events, 
                _selectedDay ?? _focusedDay
              ),
              editable: false,
            ),
          ),
      ],
    );
  }
}
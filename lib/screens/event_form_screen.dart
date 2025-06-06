import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/event_service.dart';
import '../models/event_model.dart';
import 'package:intl/intl.dart';

class EventFormScreen extends StatefulWidget {
  final CalendarEvent? event;
  const EventFormScreen({super.key, this.event});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String? description;
  DateTime? startTime;
  DateTime? endTime;
  String? color;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      title = widget.event!.title;
      description = widget.event!.description;
      startTime = widget.event!.startTime;
      endTime = widget.event!.endTime;
      color = widget.event!.color;
    }
  }

  Future<DateTime?> _showDateTimePicker(BuildContext context, DateTime? initialDateTime) async {
    final date = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );
    
    if (date != null) {
      final time = await showTimePicker(
        context: context,
        initialTime: initialDateTime != null 
            ? TimeOfDay.fromDateTime(initialDateTime)
            : TimeOfDay.now(),
      );
      
      if (time != null) {
        return DateTime(
          date.year, 
          date.month, 
          date.day, 
          time.hour, 
          time.minute
        );
      }
    }
    return null;
  }

  Widget _buildColorPicker() {
    return DropdownButtonFormField<String>(
      value: color,
      decoration: const InputDecoration(labelText: 'Color'),
      items: const [
        DropdownMenuItem(value: '#FF0000', child: Text('Red')),
        DropdownMenuItem(value: '#00FF00', child: Text('Green')),
        DropdownMenuItem(value: '#0000FF', child: Text('Blue')),
        // Add more colors as needed
      ],
      onChanged: (value) => setState(() => color = value),
    );
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;
    if (startTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a start time')),
      );
      return false;
    }
    if (endTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select an end time')),
      );
      return false;
    }
    if (endTime!.isBefore(startTime!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End time must be after start time')),
      );
      return false;
    }
    return true;
  }

  Future<void> _saveEvent() async {
    if (!_validateForm()) return;

    try {
      final event = CalendarEvent(
        id: widget.event?.id ?? '',
        title: title,
        description: description,
        startTime: startTime!,
        endTime: endTime!,
        createdBy: context.read<AuthService>().user!.uid,
        color: color,
        createdAt: widget.event?.createdAt ?? DateTime.now(),
      );

      if (widget.event == null) {
        await context.read<EventService>().addEvent(event);
      } else {
        await context.read<EventService>().updateEvent(event);
      }
      
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving event: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.event == null ? 'Add Event' : 'Edit Event'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                initialValue: title,
                decoration: const InputDecoration(labelText: 'Title'),
                onChanged: (v) => setState(() => title = v),
                validator: (v) => v?.isEmpty ?? true ? 'Enter title' : null,
              ),
              TextFormField(
                initialValue: description,
                decoration: const InputDecoration(labelText: 'Description (optional)'),
                onChanged: (v) => setState(() => description = v),
                maxLines: 3,
              ),
              ListTile(
                title: Text('Start Time: ${startTime != null ? 
                  DateFormat('yyyy-MM-dd HH:mm').format(startTime!) : 'Select'}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final datetime = await _showDateTimePicker(context, startTime);
                  if (datetime != null) {
                    setState(() => startTime = datetime);
                  }
                },
              ),
              ListTile(
                title: Text('End Time: ${endTime != null ? 
                  DateFormat('yyyy-MM-dd HH:mm').format(endTime!) : 'Select'}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final datetime = await _showDateTimePicker(context, endTime);
                  if (datetime != null) {
                    setState(() => endTime = datetime);
                  }
                },
              ),
              _buildColorPicker(),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveEvent,
                child: Text(widget.event == null ? 'Add' : 'Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
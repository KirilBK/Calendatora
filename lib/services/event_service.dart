import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_model.dart';

class EventService extends ChangeNotifier {
  final _eventRef = FirebaseFirestore.instance.collection('events');

  List<CalendarEvent> _events = [];
  bool isLoading = false;
  String? error;

  List<CalendarEvent> get events => _events;

  Future<void> fetchEvents() async {
    try {
      isLoading = true;
      notifyListeners();

      final snapshot = await _eventRef.orderBy('startTime').get();
      _events = snapshot.docs
          .map((doc) => CalendarEvent.fromMap(doc.data(), doc.id))
          .toList();
      error = null;
    } catch (e) {
      error = 'Failed to load events';
      _events = [];
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addEvent(CalendarEvent event) async {
    try {
      await _eventRef.add(event.toMap());
      await fetchEvents();
      return true;
    } catch (e) {
      error = 'Failed to add event';
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateEvent(CalendarEvent event) async {
    try {
      await _eventRef.doc(event.id).update(event.toMap());
      await fetchEvents();
      return true;
    } catch (e) {
      error = 'Failed to update event';
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteEvent(String id) async {
    try {
      await _eventRef.doc(id).delete();
      await fetchEvents();
      return true;
    } catch (e) {
      error = 'Failed to delete event';
      notifyListeners();
      return false;
    }
  }
}
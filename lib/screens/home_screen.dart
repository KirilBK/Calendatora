import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/event_service.dart';
import '../widgets/calendar_widget.dart';
import 'event_form_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  bool _isLoading = false;

  final List<({Widget screen, String label, IconData icon})> _screens = const [
    (
      screen: CalendarWidget(),
      label: 'Calendar',
      icon: Icons.calendar_today,
    ),
    (
      screen: ProfileScreen(),
      label: 'Profile',
      icon: Icons.person,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<EventService>(context, listen: false).fetchEvents();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading events: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _navigateToEventForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const EventFormScreen(),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_screens[_selectedIndex].label),
        actions: [
          if (_selectedIndex == 0)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _fetchEvents,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _screens[_selectedIndex].screen,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: _screens
            .map((screen) => BottomNavigationBarItem(
                  icon: Icon(screen.icon),
                  label: screen.label,
                ))
            .toList(),
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
      floatingActionButton: _selectedIndex == 0 && auth.user != null
          ? FloatingActionButton(
              onPressed: _navigateToEventForm,
              tooltip: 'Add Event',
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
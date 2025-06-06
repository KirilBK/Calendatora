import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import '../services/event_service.dart';
import '../widgets/event_list.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  // Simple widget to display user information
  Widget _buildUserInfo(String label, String value) {
    return Text(
      '$label: $value',
      style: TextStyle(
        fontSize: label == 'Name' ? 18 : 16,
      ),
    );
  }

  // Basic error handling for logout
  void _handleLogout(BuildContext context, AuthService auth) {
    try {
      auth.logout();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Logout failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    final eventService = Provider.of<EventService>(context);

    // Basic filtering of user events
    final myEvents = eventService.events
        .where((event) => event.createdBy == (auth.user?.uid ?? ''))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (auth.user != null) ...[
            _buildUserInfo('Name', auth.user!.name),
            _buildUserInfo('Email', auth.user!.email),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _handleLogout(context, auth),
              child: const Text('Logout'),
            ),
            const SizedBox(height: 24),
            const Text(
              'My Events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: EventList(
                events: myEvents,
                editable: true,
              ),
            ),
          ] else
            const Text(
              'Guest User',
              style: TextStyle(fontSize: 18),
            ),
        ],
      ),
    );
  }
}
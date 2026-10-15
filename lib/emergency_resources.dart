
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyResourcesScreen extends StatelessWidget {
  const EmergencyResourcesScreen({super.key});

  static const List<Map<String, String>> resources = [
    {
      'name': 'National Emergency Number',
      'number': '112',
      'description': 'Police, fire and medical emergencies',
    },
    {
      'name': 'Ambulance',
      'number': '108',
      'description': 'Ambulance assistance in many Indian states',
    },
    {
      'name': 'Fire Service',
      'number': '101',
      'description': 'Fire and rescue services',
    },
    {
      'name': 'Police',
      'number': '100',
      'description': 'Police assistance',
    },
  ];

  Future<void> _callNumber(
    BuildContext context,
    String number,
  ) async {
    try {
      final opened = await launchUrl(
        Uri(scheme: 'tel', path: number),
        mode: LaunchMode.externalApplication,
      );

      if (!context.mounted || opened) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open dialer for $number.')),
      );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone dialer is unavailable.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Emergency Resources'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.red.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'In an emergency in India, call 112. '
                'Check local availability of other helplines.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final resource in resources)
            Card(
              child: ListTile(
                leading: const CircleAvatar(
                  child: Icon(Icons.medical_services),
                ),
                title: Text(
                  resource['name']!,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  '${resource['description']}\n'
                  'Number: ${resource['number']}',
                ),
                isThreeLine: true,
                trailing: IconButton(
                  tooltip: 'Open phone dialer',
                  icon: const Icon(
                    Icons.call,
                    color: Colors.green,
                  ),
                  onPressed: () => _callNumber(
                    context,
                    resource['number']!,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const JeevanRakshaApp());
}

class JeevanRakshaApp extends StatelessWidget {
  const JeevanRakshaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JEEVAN RAKSHA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.red),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openEmergencyDialer(BuildContext context) async {
    try {
      final opened = await launchUrl(
        Uri(scheme: 'tel', path: '112'),
        mode: LaunchMode.externalApplication,
      );

      if (!context.mounted || opened) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open the phone dialer. '
              'If possible, call 112 directly.'),
        ),
      );
    } on PlatformException {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open the phone dialer.'),
        ),
      );
    }
  }

  void _openFeature(
    BuildContext context,
    String title,
    IconData icon,
    String description,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => FeatureScreen(
          title: title,
          icon: icon,
          description: description,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'JEEVAN RAKSHA',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const Text(
              'Your safety, our priority.',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Emergency assistance and essential first-aid '
              'information in one place.',
            ),
            const SizedBox(height: 20),

            // Emergency SOS
            Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(
                      Icons.health_and_safety,
                      color: Colors.red,
                      size: 44,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Emergency SOS',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'For emergencies in India, call 112.',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () => _openEmergencyDialer(context),
                        icon: const Icon(Icons.call),
                        label: const Text('Open dialer for 112'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      'Review the number before placing a call.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              'Explore features',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            _FeatureCard(
              icon: Icons.menu_book,
              title: 'First Aid Guide',
              subtitle: 'Explore emergency first-aid topics',
              onTap: () => _openFeature(
                context,
                'First Aid Guide',
                Icons.menu_book,
                'First-aid guidance will be added here.',
              ),
            ),
            _FeatureCard(
              icon: Icons.contacts,
              title: 'Emergency Contacts',
              subtitle: 'Plan who to contact in an emergency',
              onTap: () => _openFeature(
                context,
                'Emergency Contacts',
                Icons.contacts,
                'Contact management will be added here.',
              ),
            ),
            _FeatureCard(
              icon: Icons.medical_services,
              title: 'Emergency Resources',
              subtitle: 'Find essential safety information',
              onTap: () => _openFeature(
                context,
                'Emergency Resources',
                Icons.medical_services,
                'Emergency resources will be added here.',
              ),
            ),

            const SizedBox(height: 16),
            const Text(
              'Prototype: medical guidance should be reviewed '
              'by qualified professionals.',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Icon(icon, color: Colors.red, size: 32),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

class FeatureScreen extends StatelessWidget {
  const FeatureScreen({
    super.key,
    required this.title,
    required this.icon,
    required this.description,
  });

  final String title;
  final IconData icon;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 64, color: Colors.red),
              const SizedBox(height: 20),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                description,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
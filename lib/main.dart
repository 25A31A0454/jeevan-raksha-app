
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

import 'emergency_contacts.dart';
import 'emergency_resources.dart';

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
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.red,
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

// --------------------------------------------------
// SPLASH SCREEN
// --------------------------------------------------

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE53935),
              Color(0xFFB71C1C),
              Color(0xFF7F0000),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(height: 20),
                Column(
                  children: [
                    Container(
                      width: 140,
                      height: 140,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: const Icon(
                        Icons.health_and_safety,
                        size: 100,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'JEEVAN RAKSHA',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Be Prepared • Stay Safe • Save Lives',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Your personal emergency\n'
                      'assistance companion',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 23,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Essential emergency information,\n'
                      'right when you need it.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 15,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton(
                        onPressed: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute<void>(
                              builder: (_) => const HomeScreen(),
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.red.shade900,
                        ),
                        child: const Text(
                          'Get Started',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Made for a safer community',
                      style: TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --------------------------------------------------
// HOME SCREEN
// --------------------------------------------------

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> _openEmergencyDialer(
    BuildContext context,
  ) async {
    try {
      final opened = await launchUrl(
        Uri(scheme: 'tel', path: '112'),
        mode: LaunchMode.externalApplication,
      );

      if (!context.mounted || opened) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Unable to open the phone dialer.'),
        ),
      );
    } on PlatformException {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone dialer is unavailable.'),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the phone dialer.'),
        ),
      );
    }
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
                        onPressed: () =>
                            _openEmergencyDialer(context),
                        icon: const Icon(Icons.call),
                        label: const Text('Open dialer for 112'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
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
              'Explore Features',
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
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const FirstAidGuideScreen(),
                  ),
                );
              },
            ),

            _FeatureCard(
              icon: Icons.contacts,
              title: 'Emergency Contacts',
              subtitle: 'Save and call trusted contacts',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => const EmergencyContactsPage(),
                  ),
                );
              },
            ),

            _FeatureCard(
              icon: Icons.medical_services,
              title: 'Emergency Resources',
              subtitle: 'Access emergency helplines',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) =>
                        const EmergencyResourcesScreen(),
                  ),
                );
              },
            ),

            const SizedBox(height: 16),
            const Text(
              'Medical information is educational and does not '
              'replace professional medical care.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --------------------------------------------------
// REUSABLE FEATURE CARD
// --------------------------------------------------

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
        leading: Icon(
          icon,
          color: Colors.red,
          size: 32,
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}

// --------------------------------------------------
// FIRST AID GUIDE
// --------------------------------------------------

class FirstAidGuideScreen extends StatelessWidget {
  const FirstAidGuideScreen({super.key});

  static const List<Map<String, Object>> topics = [
    {
      'title': 'CPR and cardiac emergencies',
      'subtitle': 'Respond to suspected cardiac arrest',
      'icon': Icons.favorite,
    },
    {
      'title': 'Severe bleeding',
      'subtitle': 'Control bleeding and get emergency help',
      'icon': Icons.water_drop,
    },
    {
      'title': 'Burns',
      'subtitle': 'Learn safe first aid for burns',
      'icon': Icons.local_fire_department,
    },
    {
      'title': 'Choking, seizures and poisoning',
      'subtitle': 'Learn basic emergency response',
      'icon': Icons.medical_information,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Aid Guide'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.red.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'EMERGENCY? Call 112 in India. Do not delay '
                'emergency help to read this guide.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final topic in topics)
            Card(
              child: ListTile(
                leading: Icon(
                  topic['icon'] as IconData,
                  color: Colors.red,
                  size: 32,
                ),
                title: Text(
                  topic['title'] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(topic['subtitle'] as String),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (_) => FirstAidTopicScreen(
                        title: topic['title'] as String,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

// --------------------------------------------------
// FIRST AID TOPIC DETAILS
// --------------------------------------------------

class FirstAidTopicScreen extends StatelessWidget {
  const FirstAidTopicScreen({
    super.key,
    required this.title,
  });

  final String title;

  List<String> _getSteps() {
    switch (title) {
      case 'CPR and cardiac emergencies':
        return [
          'Check that the scene is safe.',
          'Check responsiveness and normal breathing. '
              'Gasping is not normal breathing.',
          'If the person is unresponsive and not breathing '
              'normally, call 112 and ask someone to get an AED.',
          'For an adult, start chest compressions in the center '
              'of the chest at 100–120 per minute, about 5–6 cm '
              'deep. Allow the chest to recoil.',
          'If trained, give 30 compressions and 2 rescue breaths. '
              'Otherwise, provide hands-only CPR.',
          'Use an AED as soon as available and follow its '
              'instructions until help takes over.',
        ];

      case 'Severe bleeding':
        return [
          'Ensure the scene is safe and call 112 for severe '
              'or life-threatening bleeding.',
          'Apply firm, continuous direct pressure with gauze '
              'or a clean cloth.',
          'If blood soaks through, add material without '
              'removing the original dressing.',
          'Do not remove embedded objects. Apply pressure '
              'around them.',
          'For life-threatening limb bleeding, use a proper '
              'tourniquet if available and you know how.',
          'Keep the person still and warm while waiting for help.',
        ];

      case 'Burns':
        return [
          'Stop the burning process and move away from danger.',
          'Cool the burn under cool running water for 20 minutes. '
              'Do not use ice.',
          'Remove nearby jewellery and loose clothing unless '
              'stuck to the skin.',
          'Do not apply toothpaste, butter, oil or creams. '
              'Do not break blisters.',
          'Loosely cover with a clean, non-fluffy dressing.',
          'Seek urgent medical care for serious, deep, large, '
              'electrical or chemical burns.',
        ];

      default:
        return [
          'CHOKING: For a conscious adult with severe choking, '
              'call for help and give 5 back blows followed by '
              '5 abdominal thrusts. Repeat as needed. Infants '
              'need age-appropriate first aid.',
          'SEIZURES: Protect the person from hazards, cushion '
              'their head and time the seizure. Do not restrain '
              'them or put anything in their mouth.',
          'POISONING: Seek urgent professional advice. Do not '
              'induce vomiting or give home remedies. Keep the '
              'product packaging for medical professionals.',
          'For unconsciousness, breathing difficulty or another '
              'life-threatening emergency, call 112 in India.',
        ];
    }
  }

  IconData _getIcon() {
    switch (title) {
      case 'CPR and cardiac emergencies':
        return Icons.favorite;
      case 'Severe bleeding':
        return Icons.water_drop;
      case 'Burns':
        return Icons.local_fire_department;
      default:
        return Icons.medical_information;
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = _getSteps();

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Icon(_getIcon(), size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: Colors.red.shade50,
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'For life-threatening emergencies in India, call '
                '112 and follow the emergency dispatcher instructions.',
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (int i = 0; i < steps.length; i++)
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.red.shade100,
                  child: Text('${i + 1}'),
                ),
                title: Text(steps[i]),
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            'Educational guidance only. This guide does not '
            'replace professional medical care or training.',
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
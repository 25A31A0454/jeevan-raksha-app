
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContact {
  final String name;
  final String relationship;
  final String phone;

  const EmergencyContact({
    required this.name,
    required this.relationship,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'relationship': relationship,
      'phone': phone,
    };
  }

  factory EmergencyContact.fromJson(Map<String, dynamic> json) {
    return EmergencyContact(
      name: json['name'] as String,
      relationship: json['relationship'] as String,
      phone: json['phone'] as String,
    );
  }
}

class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({super.key});

  @override
  State<EmergencyContactsPage> createState() =>
      _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  static const String storageKey = 'jeevan_raksha_contacts';

  List<EmergencyContact> contacts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadContacts();
  }

  // Load saved contacts from local storage.
  Future<void> loadContacts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getString(storageKey);

      List<EmergencyContact> loaded = [];

      if (saved != null) {
        final decoded = jsonDecode(saved) as List<dynamic>;

        loaded = decoded.map((item) {
          return EmergencyContact.fromJson(
            Map<String, dynamic>.from(item as Map),
          );
        }).toList();
      }

      if (!mounted) return;

      setState(() {
        contacts = loaded;
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not load saved contacts.'),
        ),
      );
    }
  }

  // Save contacts locally on the device.
  Future<void> saveContacts() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(
      storageKey,
      jsonEncode(
        contacts.map((contact) => contact.toJson()).toList(),
      ),
    );
  }

  // Show a form and add a new emergency contact.
  Future<void> addContact() async {
    final nameController = TextEditingController();
    final relationshipController = TextEditingController();
    final phoneController = TextEditingController();

    final formKey = GlobalKey<FormState>();

    try {
      final result = await showDialog<EmergencyContact>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: const Text('Add Emergency Contact'),
            content: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                        prefixIcon: Icon(Icons.person),
                      ),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: relationshipController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Relationship',
                        hintText: 'Family, friend, doctor...',
                        prefixIcon: Icon(Icons.people),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        prefixIcon: Icon(Icons.phone),
                      ),
                      validator: (value) {
                        final phone = value?.trim() ?? '';
                        final validPhone =
                            RegExp(r'^\+?[0-9]{7,15}$');

                        if (!validPhone.hasMatch(phone)) {
                          return 'Enter a valid phone number';
                        }

                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancel'),
              ),
              FilledButton(
                onPressed: () {
                  if (!formKey.currentState!.validate()) return;

                  Navigator.pop(
                    dialogContext,
                    EmergencyContact(
                      name: nameController.text.trim(),
                      relationship:
                          relationshipController.text.trim().isEmpty
                              ? 'Emergency contact'
                              : relationshipController.text.trim(),
                      phone: phoneController.text.trim(),
                    ),
                  );
                },
                child: const Text('Save Contact'),
              ),
            ],
          );
        },
      );

      if (result == null || !mounted) return;

      final previousContacts = List<EmergencyContact>.from(contacts);

      setState(() {
        contacts.add(result);
      });

      try {
        await saveContacts();

        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Emergency contact saved successfully.'),
          ),
        );
      } catch (_) {
        if (!mounted) return;

        setState(() {
          contacts = previousContacts;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not save the contact.'),
          ),
        );
      }
    } finally {
      nameController.dispose();
      relationshipController.dispose();
      phoneController.dispose();
    }
  }

  // Open the phone dialer for the selected contact.
  Future<void> callContact(EmergencyContact contact) async {
    final uri = Uri(
      scheme: 'tel',
      path: contact.phone,
    );

    try {
      final opened = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!mounted || opened) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open the phone dialer.'),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone dialer is unavailable.'),
        ),
      );
    }
  }

  // Delete a contact and update local storage.
  Future<void> deleteContact(int index) async {
    final contact = contacts[index];

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete Contact?'),
        content: Text(
          'Remove ${contact.name} from your emergency contacts?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final previousContacts = List<EmergencyContact>.from(contacts);

    setState(() {
      contacts.removeAt(index);
    });

    try {
      await saveContacts();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${contact.name} deleted.'),
          action: SnackBarAction(
            label: 'UNDO',
            onPressed: () async {
              final currentContacts =
                  List<EmergencyContact>.from(contacts);

              setState(() {
                contacts.insert(
                  index.clamp(0, contacts.length),
                  contact,
                );
              });

              try {
                await saveContacts();
              } catch (_) {
                if (!mounted) return;

                setState(() {
                  contacts = currentContacts;
                });

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Could not restore the contact.'),
                  ),
                );
              }
            },
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        contacts = previousContacts;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not delete the contact.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Emergency Contacts',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isLoading ? null : addContact,
        icon: const Icon(Icons.person_add_alt_1),
        label: const Text('Add Contact'),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : contacts.isEmpty
                ? _buildEmptyState()
                : _buildContactsList(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.contact_phone,
              size: 76,
              color: Colors.red.shade300,
            ),
            const SizedBox(height: 20),
            const Text(
              'No Emergency Contacts Yet',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Add family members, trusted friends, or your '
              'doctor so their numbers are available when needed.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: addContact,
              icon: const Icon(Icons.add),
              label: const Text('Add Your First Contact'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactsList() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
      children: [
        Card(
          color: Colors.red.shade50,
          child: const Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: Colors.red,
                  size: 30,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your saved contacts are stored on this device.',
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 8),
        for (int index = 0; index < contacts.length; index++)
          _buildContactCard(contacts[index], index),
      ],
    );
  }

  Widget _buildContactCard(
    EmergencyContact contact,
    int index,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.red.shade50,
          child: const Icon(
            Icons.person,
            color: Colors.red,
          ),
        ),
        title: Text(
          contact.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contact.relationship),
              const SizedBox(height: 3),
              Text(contact.phone),
            ],
          ),
        ),
        isThreeLine: true,
        trailing: PopupMenuButton<String>(
          tooltip: 'Contact options',
          onSelected: (value) {
            if (value == 'call') {
              callContact(contact);
            } else if (value == 'delete') {
              deleteContact(index);
            }
          },
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'call',
              child: ListTile(
                leading: Icon(Icons.call),
                title: Text('Call'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
            PopupMenuItem(
              value: 'delete',
              child: ListTile(
                leading: Icon(Icons.delete_outline),
                title: Text('Delete'),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ],
        ),
        onTap: () => callContact(contact),
      ),
    );
  }
}
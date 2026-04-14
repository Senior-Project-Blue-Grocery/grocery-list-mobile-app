import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grocery_app/models/grocery_list.dart';
import 'package:grocery_app/services/firestore_service.dart';

class AccountLinkingScreen extends StatefulWidget {
  const AccountLinkingScreen({super.key});

  @override
  State<AccountLinkingScreen> createState() => _AccountLinkingScreenState();
}

class _AccountLinkingScreenState extends State<AccountLinkingScreen> {
  final FirestoreService firestoreService = FirestoreService();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _showSendInviteDialog(
    BuildContext context,
    List<GroceryList> ownedLists,
  ) async {
    final TextEditingController emailController = TextEditingController();
    String? selectedListId;
    String? selectedListName;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Send Invite'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Choose a list',
                ),
                items: ownedLists.map((list) {
                  return DropdownMenuItem<String>(
                    value: list.id,
                    child: Text(list.name),
                  );
                }).toList(),
                onChanged: (value) {
                  selectedListId = value;

                  final matchedList = ownedLists.firstWhere(
                    (list) => list.id == value,
                  );
                  selectedListName = matchedList.name;
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Enter user email',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final email = emailController.text.trim().toLowerCase();

                if (selectedListId == null ||
                    selectedListName == null ||
                    email.isEmpty ||
                    user == null) {
                  return;
                }

                final invitedUserId =
                    await firestoreService.getUserIdByEmail(email);

                if (invitedUserId == null) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('No user found with that email'),
                      ),
                    );
                  }
                  return;
                }

                if (invitedUserId == user!.uid) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You cannot invite yourself'),
                      ),
                    );
                  }
                  return;
                }

                await firestoreService.sendInvite(
                  listId: selectedListId!,
                  listName: selectedListName!,
                  ownerId: user!.uid,
                  invitedUserId: invitedUserId,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Invite sent')),
                  );
                }
              },
              child: const Text('Send'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(
          child: Text('No user signed in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Linking'),
      ),
      body: StreamBuilder<List<GroceryList>>(
        stream: firestoreService.getOwnedLists(user!.uid),
        builder: (context, ownedSnapshot) {
          final ownedLists = ownedSnapshot.data ?? [];

          return StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getPendingInvites(user!.uid),
            builder: (context, inviteSnapshot) {
              if (inviteSnapshot.connectionState == ConnectionState.waiting ||
                  ownedSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (inviteSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${inviteSnapshot.error}'),
                );
              }

              if (ownedSnapshot.hasError) {
                return Center(
                  child: Text('Error: ${ownedSnapshot.error}'),
                );
              }

              final inviteDocs = inviteSnapshot.data?.docs ?? [];

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton.icon(
                      onPressed: ownedLists.isEmpty
                          ? null
                          : () => _showSendInviteDialog(context, ownedLists),
                      icon: const Icon(Icons.person_add_alt_1),
                      label: const Text('Send Invite'),
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Pending Invites',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (inviteDocs.isEmpty)
                    const Text(
                      'No pending invites right now.',
                      style: TextStyle(fontSize: 16),
                    )
                  else
                    ...inviteDocs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final listId = data['listId'] ?? '';
                      final listName = data['listName'] ?? 'Unnamed List';

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                listName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text('You were invited to join this list.'),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        await firestoreService.acceptInvite(
                                          inviteId: doc.id,
                                          listId: listId,
                                          userId: user!.uid,
                                        );

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Invite accepted'),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Accept'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: OutlinedButton(
                                      onPressed: () async {
                                        await firestoreService
                                            .declineInvite(doc.id);

                                        if (context.mounted) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text('Invite declined'),
                                            ),
                                          );
                                        }
                                      },
                                      child: const Text('Decline'),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
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

  Future<void> _leaveList(String listId) async {
    if (user == null) return;

    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Leave list?'),
          content:
              const Text('Are you sure you want to leave this shared list?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Leave'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await firestoreService.leaveSharedList(listId, user!.uid);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You left the list')),
        );
      }
    }
  }

  Future<void> _confirmRemoveMember({
    required String listId,
    required String memberId,
    required String memberName,
  }) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Remove member?'),
          content: Text('Remove $memberName from this list?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Remove'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await firestoreService.removeUserFromList(listId, memberId);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Member removed')),
        );
      }
    }
  }

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

  Widget _buildMembersList(
    List<Map<String, dynamic>> members,
    String listId,
    bool isOwner,
  ) {
    if (members.isEmpty) {
      return const Text('No shared members yet');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: members.map((member) {
        final name = member['name'] ?? 'Unknown User';
        final email = member['email'] ?? 'No email';
        final memberId = member['uid'];

        return Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Row(
            children: [
              Expanded(
                child: Text('• $name ($email)'),
              ),
              if (isOwner)
                IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _confirmRemoveMember(
                      listId: listId,
                      memberId: memberId,
                      memberName: name,
                    );
                  },
                ),
            ],
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (user == null) {
      return const Scaffold(
        body: Center(child: Text('No user signed in')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account Linking'),
      ),
      body: StreamBuilder<List<GroceryList>>(
        stream: firestoreService.getUserLists(user!.uid),
        builder: (context, listSnapshot) {
          if (!listSnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final lists = listSnapshot.data!;
          final ownedLists =
              lists.where((list) => list.ownerId == user!.uid).toList();
          final sharedLists =
              lists.where((list) => list.ownerId != user!.uid).toList();

          return StreamBuilder<QuerySnapshot>(
            stream: firestoreService.getPendingInvites(user!.uid),
            builder: (context, inviteSnapshot) {
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
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (inviteDocs.isEmpty)
                    const Text('No pending invites')
                  else
                    ...inviteDocs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final listId = data['listId'];
                      final listName = data['listName'];

                      return Card(
                        child: ListTile(
                          title: Text(listName),
                          subtitle: const Text('You were invited'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.check),
                                onPressed: () async {
                                  await firestoreService.acceptInvite(
                                    inviteId: doc.id,
                                    listId: listId,
                                    userId: user!.uid,
                                  );
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () async {
                                  await firestoreService.declineInvite(doc.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  const SizedBox(height: 24),
                  const Text(
                    'Your Lists',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (ownedLists.isEmpty)
                    const Text('You do not own any lists')
                  else
                    ...ownedLists.map((list) {
                      return FutureBuilder<Map<String, dynamic>?>(
                        future: firestoreService.getUserById(list.ownerId),
                        builder: (context, ownerSnapshot) {
                          final ownerName =
                              ownerSnapshot.data?['name'] ?? 'Unknown Owner';

                          return FutureBuilder<List<Map<String, dynamic>>>(
                            future:
                                firestoreService.getUsersByIds(list.sharedWith),
                            builder: (context, membersSnapshot) {
                              final members = membersSnapshot.data ?? [];

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        list.name,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text('Owner: $ownerName'),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Members',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      _buildMembersList(
                                        members,
                                        list.id,
                                        true,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      );
                    }),
                  const SizedBox(height: 24),
                  const Text(
                    'Shared Lists',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 12),
                  if (sharedLists.isEmpty)
                    const Text('You are not part of any shared lists')
                  else
                    ...sharedLists.map((list) {
                      return FutureBuilder<Map<String, dynamic>?>(
                        future: firestoreService.getUserById(list.ownerId),
                        builder: (context, ownerSnapshot) {
                          final ownerName =
                              ownerSnapshot.data?['name'] ?? 'Unknown Owner';

                          return FutureBuilder<List<Map<String, dynamic>>>(
                            future:
                                firestoreService.getUsersByIds(list.sharedWith),
                            builder: (context, membersSnapshot) {
                              final members = membersSnapshot.data ?? [];

                              return Card(
                                margin: const EdgeInsets.only(bottom: 12),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              list.name,
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              Icons.exit_to_app,
                                              color: Colors.red,
                                            ),
                                            onPressed: () =>
                                                _leaveList(list.id),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 6),
                                      Text('Owner: $ownerName'),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Members',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      _buildMembersList(
                                        members,
                                        list.id,
                                        false,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
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
import 'package:cloud_firestore/cloud_firestore.dart';

class ListInvite {
  final String id;
  final String listId;
  final String listName;
  final String ownerId;
  final String invitedUserId;
  final String status;
  final Timestamp? createdAt;
  final Timestamp? respondedAt;

  ListInvite({
    required this.id,
    required this.listId,
    required this.listName,
    required this.ownerId,
    required this.invitedUserId,
    required this.status,
    this.createdAt,
    this.respondedAt,
  });

  factory ListInvite.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return ListInvite(
      id: doc.id,
      listId: data['listId'] ?? '',
      listName: data['listName'] ?? '',
      ownerId: data['ownerId'] ?? '',
      invitedUserId: data['invitedUserId'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: data['createdAt'],
      respondedAt: data['respondedAt'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'listId': listId,
      'listName': listName,
      'ownerId': ownerId,
      'invitedUserId': invitedUserId,
      'status': status,
      'createdAt': createdAt,
      'respondedAt': respondedAt,
    };
  }
}
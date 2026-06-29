class User {
  final String id;
  final String name;
  final String avatarUrl;

  const User({
    required this.id,
    required this.name,
    required this.avatarUrl,
  });
}

class Message {
  final String id;
  final String senderId;
  final String text;
  final DateTime timestamp;

  const Message({
    required this.id,
    required this.senderId,
    required this.text,
    required this.timestamp,
  });
}

class Conversation {
  final String id;
  final User otherUser;
  final List<Message> messages;

  Message? get lastMessage => messages.isNotEmpty ? messages.last : null;

  const Conversation({
    required this.id,
    required this.otherUser,
    required this.messages,
  });
}

// Mock Data
final currentUser = const User(
  id: 'u1',
  name: 'Me',
  avatarUrl: 'https://i.pravatar.cc/150?u=me',
);

final mockConversations = [
  Conversation(
    id: 'c1',
    otherUser: const User(id: 'u2', name: 'Alice Smith', avatarUrl: 'https://i.pravatar.cc/150?u=alice'),
    messages: [
      Message(id: 'm1', senderId: 'u2', text: 'Hey, are we still on for tomorrow?', timestamp: DateTime.now().subtract(const Duration(hours: 2))),
      Message(id: 'm2', senderId: 'u1', text: 'Yes! See you at 10.', timestamp: DateTime.now().subtract(const Duration(hours: 1))),
    ],
  ),
  Conversation(
    id: 'c2',
    otherUser: const User(id: 'u3', name: 'Bob Jones', avatarUrl: 'https://i.pravatar.cc/150?u=bob'),
    messages: [
      Message(id: 'm3', senderId: 'u3', text: 'Did you send the report?', timestamp: DateTime.now().subtract(const Duration(days: 1))),
    ],
  ),
  Conversation(
    id: 'c3',
    otherUser: const User(id: 'u4', name: 'Charlie Davis', avatarUrl: 'https://i.pravatar.cc/150?u=charlie'),
    messages: [
      Message(id: 'm4', senderId: 'u4', text: 'Check out this new framework!', timestamp: DateTime.now().subtract(const Duration(days: 2))),
      Message(id: 'm5', senderId: 'u1', text: 'Looks interesting, I will take a look.', timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 22))),
    ],
  ),
];

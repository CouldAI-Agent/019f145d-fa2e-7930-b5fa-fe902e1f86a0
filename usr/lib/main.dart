import 'package:flutter/material.dart';
import 'models.dart';

void main() {
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Chat',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ChatLayout(),
      },
    );
  }
}

class ChatLayout extends StatefulWidget {
  const ChatLayout({super.key});

  @override
  State<ChatLayout> createState() => _ChatLayoutState();
}

class _ChatLayoutState extends State<ChatLayout> {
  Conversation? _selectedConversation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            // Mobile Layout
            if (_selectedConversation == null) {
              return ChatList(
                onConversationSelected: (conv) {
                  setState(() {
                    _selectedConversation = conv;
                  });
                },
              );
            } else {
              return ChatDetail(
                conversation: _selectedConversation!,
                onBack: () {
                  setState(() {
                    _selectedConversation = null;
                  });
                },
              );
            }
          } else {
            // Desktop / Tablet Layout
            return Row(
              children: [
                SizedBox(
                  width: 350,
                  child: ChatList(
                    selectedConversationId: _selectedConversation?.id,
                    onConversationSelected: (conv) {
                      setState(() {
                        _selectedConversation = conv;
                      });
                    },
                  ),
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(
                  child: _selectedConversation == null
                      ? const Center(
                          child: Text(
                            'Select a conversation to start chatting',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : ChatDetail(
                          conversation: _selectedConversation!,
                        ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class ChatList extends StatelessWidget {
  final String? selectedConversationId;
  final ValueChanged<Conversation> onConversationSelected;

  const ChatList({
    super.key,
    this.selectedConversationId,
    required this.onConversationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: mockConversations.length,
        itemBuilder: (context, index) {
          final conv = mockConversations[index];
          final isSelected = conv.id == selectedConversationId;
          
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(conv.otherUser.avatarUrl),
            ),
            title: Text(
              conv.otherUser.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              conv.lastMessage?.text ?? '',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: conv.lastMessage != null
                ? Text(
              _formatDate(conv.lastMessage!.timestamp),
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  )
                : null,
            selected: isSelected,
            selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withOpacity(0.5),
            onTap: () => onConversationSelected(conv),
          );
        },
      ),
    );
  }
}

class ChatDetail extends StatefulWidget {
  final Conversation conversation;
  final VoidCallback? onBack;

  const ChatDetail({
    super.key,
    required this.conversation,
    this.onBack,
  });

  @override
  State<ChatDetail> createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      widget.conversation.messages.add(
        Message(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          senderId: currentUser.id,
          text: _messageController.text,
          timestamp: DateTime.now(),
        ),
      );
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: widget.onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: widget.onBack,
              )
            : null,
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.conversation.otherUser.avatarUrl),
              radius: 16,
            ),
            const SizedBox(width: 12),
            Text(widget.conversation.otherUser.name),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.call),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true, // Display messages from bottom to top
              itemCount: widget.conversation.messages.length,
              itemBuilder: (context, index) {
                // Reverse the index because of reverse: true
                final message = widget.conversation.messages[widget.conversation.messages.length - 1 - index];
                final isMe = message.senderId == currentUser.id;

                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isMe 
                          ? Theme.of(context).colorScheme.primary 
                          : Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                      children: [
                        Text(
                          message.text,
                          style: TextStyle(
                            color: isMe ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                        _formatDate(message.timestamp),
                          style: TextStyle(
                            fontSize: 10,
                            color: isMe 
                                ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7) 
                                : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          SafeArea(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    offset: const Offset(0, -1),
                    blurRadius: 4,
                    color: Colors.black.withOpacity(0.05),
                  ),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.attach_file),
                    onPressed: () {},
                    color: Colors.grey,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: const InputDecoration(
                        hintText: 'Type a message...',
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send),
                    onPressed: _sendMessage,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/foundation.dart';
import '../models/message.dart';

class ChatProvider with ChangeNotifier {
  List<Chat> _chats = [];
  List<Message> _messages = [];
  String? _currentChatId;

  List<Chat> get chats => _chats;
  List<Message> get messages => _messages;
  String? get currentChatId => _currentChatId;

  ChatProvider() {
    _loadSampleChats();
  }

  void _loadSampleChats() {
    // Sample chats for demo
    _chats = [];
  }

  void createChat({
    required String participant1Id,
    required String participant1Name,
    required String participant2Id,
    required String participant2Name,
    required String propertyId,
    required String propertyTitle,
  }) {
    final chatId = DateTime.now().millisecondsSinceEpoch.toString();
    final chat = Chat(
      id: chatId,
      participant1Id: participant1Id,
      participant1Name: participant1Name,
      participant2Id: participant2Id,
      participant2Name: participant2Name,
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      createdAt: DateTime.now(),
    );
    _chats.insert(0, chat);
    notifyListeners();
  }

  Chat? getChatByPropertyAndParticipant(String propertyId, String participantId) {
    try {
      return _chats.firstWhere(
        (chat) =>
            chat.propertyId == propertyId &&
            (chat.participant1Id == participantId || chat.participant2Id == participantId),
      );
    } catch (e) {
      return null;
    }
  }

  void openChat(String chatId) {
    _currentChatId = chatId;
    _loadMessages(chatId);
    notifyListeners();
  }

  void _loadMessages(String chatId) {
    try {
      final chat = _chats.firstWhere((c) => c.id == chatId);
      // Filter messages for this specific chat
      _messages = _messages.where((msg) {
        return msg.propertyId == chat.propertyId &&
               ((msg.senderId == chat.participant1Id && msg.receiverId == chat.participant2Id) ||
                (msg.senderId == chat.participant2Id && msg.receiverId == chat.participant1Id));
      }).toList();
    } catch (e) {
      _messages = [];
    }
  }

  void sendMessage({
    required String chatId,
    required String senderId,
    required String senderName,
    required String receiverId,
    required String receiverName,
    required String propertyId,
    required String propertyTitle,
    required String content,
  }) {
    final message = Message(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      senderId: senderId,
      senderName: senderName,
      receiverId: receiverId,
      receiverName: receiverName,
      propertyId: propertyId,
      propertyTitle: propertyTitle,
      content: content,
      timestamp: DateTime.now(),
    );

    _messages.add(message);

    // Update chat's last message
    final chatIndex = _chats.indexWhere((chat) => chat.id == chatId);
    if (chatIndex != -1) {
      final chat = _chats[chatIndex];
      _chats[chatIndex] = Chat(
        id: chat.id,
        participant1Id: chat.participant1Id,
        participant1Name: chat.participant1Name,
        participant2Id: chat.participant2Id,
        participant2Name: chat.participant2Name,
        propertyId: chat.propertyId,
        propertyTitle: chat.propertyTitle,
        lastMessage: message,
        createdAt: chat.createdAt,
        unreadCount: receiverId == chat.participant1Id || receiverId == chat.participant2Id
            ? chat.unreadCount + 1
            : chat.unreadCount,
      );
    }

    notifyListeners();
  }

  List<Chat> getChatsForUser(String userId) {
    return _chats.where((chat) =>
        chat.participant1Id == userId || chat.participant2Id == userId).toList();
  }

  List<Message> getMessagesForChat(String chatId) {
    try {
      final chat = _chats.firstWhere((c) => c.id == chatId);
      return _messages.where((msg) {
        return msg.propertyId == chat.propertyId &&
               ((msg.senderId == chat.participant1Id && msg.receiverId == chat.participant2Id) ||
                (msg.senderId == chat.participant2Id && msg.receiverId == chat.participant1Id));
      }).toList()..sort((a, b) => a.timestamp.compareTo(b.timestamp));
    } catch (e) {
      return [];
    }
  }
}


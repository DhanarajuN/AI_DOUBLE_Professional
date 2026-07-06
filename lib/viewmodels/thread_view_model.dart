import 'package:flutter/foundation.dart';
import '../models/customer.dart';
import '../repositories/lead_repository.dart';
import '../services/chat_model_service.dart';

/// Backs [ThreadScreen]: owns the "is the model typing" flag, sends the
/// customer's/agent's messages through [LeadRepository], and asks
/// [ChatModelService] to generate the AI double's reply.
class ThreadViewModel extends ChangeNotifier {
  final String customerId;
  final LeadRepository repository;
  final ChatModelService chatService;

  bool _typing = false;
  String? _error;

  ThreadViewModel({
    required this.customerId,
    required this.repository,
    required this.chatService,
  });

  Customer get customer => repository.getById(customerId);
  List<ChatMessage> get messages => customer.thread;
  bool get isTyping => _typing;
  String? get error => _error;

  String _nowLabel() {
    final d = DateTime.now();
    return '${d.hour}:${d.minute.toString().padLeft(2, '0')}';
  }

  Future<void> send(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    repository.appendMessage(customerId, ChatMessage('me', trimmed, _nowLabel()));

    _typing = true;
    _error = null;
    notifyListeners();

    try {
      final reply = await chatService.generateReply(customer: customer, history: messages);
      repository.appendMessage(customerId, ChatMessage('them', reply, _nowLabel()));
    } catch (e) {
      _error = 'Could not reach the chat model: $e';
    } finally {
      _typing = false;
      notifyListeners();
    }
  }

  void setStatus(LeadStatus status) => repository.setStatus(customerId, status);
}

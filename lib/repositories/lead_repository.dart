import 'package:flutter/foundation.dart';
import '../data.dart';
import '../models/customer.dart';

/// Owns the in-memory list of [Customer] leads and every mutation made to it.
/// This is the single source of truth ViewModels read from and write through —
/// no screen holds its own copy of lead/thread state anymore.
class LeadRepository extends ChangeNotifier {
  List<Customer> _customers = [];
  bool _loaded = false;

  bool get loaded => _loaded;

  Future<void> load() async {
    _customers = await loadCustomers();
    _loaded = true;
    notifyListeners();
  }

  List<Customer> get customers => List.unmodifiable(_customers);

  Customer getById(String id) => _customers.firstWhere((c) => c.id == id);

  List<Customer> byStatusKey(String key) {
    if (key == 'all') return customers;
    return _customers.where((c) => c.status.key == key).toList();
  }

  int countByStatusKey(String key) => _customers.where((c) => c.status.key == key).length;

  int get newLeadCount => countByStatusKey('new');

  int get unreadCount => _customers.fold(0, (sum, c) => sum + c.unread);

  void markRead(String id) {
    getById(id).unread = 0;
    notifyListeners();
  }

  void appendMessage(String id, ChatMessage message) {
    final c = getById(id);
    c.thread.add(message);
    if (message.kind == 'me') {
      c.preview = 'You: ${message.text}';
      c.lastMe = true;
      c.time = 'now';
      if (c.status == LeadStatus.new_) c.status = LeadStatus.active;
    } else if (message.kind == 'them') {
      c.preview = message.text;
      c.lastMe = false;
      c.time = 'now';
    }
    notifyListeners();
  }

  void setStatus(String id, LeadStatus status) {
    final c = getById(id);
    c.status = status;
    if (status == LeadStatus.won) {
      c.preview = 'You: Marked as won 🎉';
      c.lastMe = true;
    }
    notifyListeners();
  }
}

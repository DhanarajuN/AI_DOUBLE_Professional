import 'package:flutter/foundation.dart';
import '../models/customer.dart';
import '../repositories/lead_repository.dart';

/// Presentation state for [ChatsScreen]: which status filter pill is active.
/// The underlying lead data itself lives in [LeadRepository].
class ChatsListViewModel extends ChangeNotifier {
  final LeadRepository repository;
  String _filter = 'all';

  ChatsListViewModel(this.repository);

  String get filter => _filter;

  List<Customer> get filtered => repository.byStatusKey(_filter);

  int countFor(String key) => repository.countByStatusKey(key);

  void setFilter(String key) {
    if (_filter == key) return;
    _filter = key;
    notifyListeners();
  }

  void openThread(String customerId) => repository.markRead(customerId);
}

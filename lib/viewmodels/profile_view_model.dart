import 'package:flutter/foundation.dart';
import '../data.dart';

/// Backs [ProfileScreen]: which editor sections are expanded, and the
/// editable list of services offered.
class ProfileViewModel extends ChangeNotifier {
  final Set<String> _openSections = {'Identity'};
  final List<String> _services = List.of(kServices);

  Set<String> get openSections => _openSections;
  List<String> get services => List.unmodifiable(_services);

  bool isOpen(String section) => _openSections.contains(section);

  void toggleSection(String section) {
    if (!_openSections.remove(section)) _openSections.add(section);
    notifyListeners();
  }

  void removeService(String service) {
    _services.remove(service);
    notifyListeners();
  }
}

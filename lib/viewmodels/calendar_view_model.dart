import 'package:flutter/foundation.dart';
import '../data.dart';

/// Backs [CalendarScreen]: which day of the month is selected, and the
/// appointments booked for it.
class CalendarViewModel extends ChangeNotifier {
  int _selectedDay = 5;

  int get selectedDay => _selectedDay;
  List<List<String>>? get appointmentsForSelectedDay => kAppts[_selectedDay];

  void selectDay(int day) {
    if (_selectedDay == day) return;
    _selectedDay = day;
    notifyListeners();
  }
}

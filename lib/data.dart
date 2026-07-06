import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'models/customer.dart';

/// Static stand-in for the future leads API response. Swap this body for an
/// `http.get(...)` call returning the same JSON shape once the backend is ready —
/// [Customer.fromJson] already matches that shape.
Future<List<Customer>> loadCustomers() async {
  final raw = await rootBundle.loadString('assets/data/customers.json');
  final list = jsonDecode(raw) as List;
  return list.map((e) => Customer.fromJson(e as Map<String, dynamic>)).toList();
}

const List<String> kServices = [
  'Home insurance',
  'Term life',
  'Health cover',
  'Claims support',
  'Policy review',
  'Motor insurance',
];

const List<List<String>> kFaqs = [
  ['Do you charge for a consultation?', 'No — the first consultation is always free.'],
  ['Which insurers do you work with?', 'I compare 20+ IRDAI-registered insurers.'],
  ['How fast can I get covered?', 'Home cover same-day; term life 3–7 days.'],
];

/// day -> list of [time, name, subject]
final Map<int, List<List<String>>> kAppts = {
  5: [
    ['4:00', 'Rahul S.', 'Home insurance consult'],
    ['5:30', 'Naveen V.', 'Health cover call'],
  ],
  8: [
    ['11:00', 'Follow-up', 'Policy review'],
  ],
  12: [
    ['2:00', 'Divya P.', 'Motor renewal'],
  ],
};

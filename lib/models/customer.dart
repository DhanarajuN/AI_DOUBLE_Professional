enum LeadStatus { new_, active, won }

extension LeadStatusX on LeadStatus {
  String get label => switch (this) {
        LeadStatus.new_ => 'New',
        LeadStatus.active => 'In progress',
        LeadStatus.won => 'Won',
      };

  String get key => switch (this) {
        LeadStatus.new_ => 'new',
        LeadStatus.active => 'active',
        LeadStatus.won => 'won',
      };
}

class ChatMessage {
  final String kind; // 'sys' | 'them' | 'me'
  final String text;
  final String time;
  ChatMessage(this.kind, this.text, [this.time = '']);
}

class Customer {
  final String id;
  final String ini;
  final String name;
  final String via;
  final String need;
  LeadStatus status;
  int unread;
  String time;
  final String loc;
  final String detail;
  final String budget;
  final String urgency;
  String preview;
  bool lastMe;
  final String quote;
  final List<ChatMessage> thread;

  Customer({
    required this.id,
    required this.ini,
    required this.name,
    required this.via,
    required this.need,
    required this.status,
    required this.unread,
    required this.time,
    required this.loc,
    required this.detail,
    required this.budget,
    required this.urgency,
    required this.preview,
    required this.lastMe,
    required this.quote,
    required this.thread,
  });
}

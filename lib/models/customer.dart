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

  static LeadStatus fromKey(String key) => switch (key) {
        'active' => LeadStatus.active,
        'won' => LeadStatus.won,
        _ => LeadStatus.new_,
      };
}

class ChatMessage {
  final String kind; // 'sys' | 'them' | 'me'
  final String text;
  final String time;
  ChatMessage(this.kind, this.text, [this.time = '']);

  factory ChatMessage.fromJson(Map<String, dynamic> json) => ChatMessage(
        json['kind'] as String,
        json['text'] as String,
        json['time'] as String? ?? '',
      );

  Map<String, dynamic> toJson() => {'kind': kind, 'text': text, 'time': time};
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

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json['id'] as String,
        ini: json['ini'] as String,
        name: json['name'] as String,
        via: json['via'] as String,
        need: json['need'] as String,
        status: LeadStatusX.fromKey(json['status'] as String),
        unread: json['unread'] as int,
        time: json['time'] as String,
        loc: json['loc'] as String,
        detail: json['detail'] as String,
        budget: json['budget'] as String,
        urgency: json['urgency'] as String,
        preview: json['preview'] as String,
        lastMe: json['lastMe'] as bool,
        quote: json['quote'] as String,
        thread: (json['thread'] as List)
            .map((m) => ChatMessage.fromJson(m as Map<String, dynamic>))
            .toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'ini': ini,
        'name': name,
        'via': via,
        'need': need,
        'status': status.key,
        'unread': unread,
        'time': time,
        'loc': loc,
        'detail': detail,
        'budget': budget,
        'urgency': urgency,
        'preview': preview,
        'lastMe': lastMe,
        'quote': quote,
        'thread': thread.map((m) => m.toJson()).toList(),
      };
}

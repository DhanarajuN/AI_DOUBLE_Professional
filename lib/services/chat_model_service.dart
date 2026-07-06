import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/customer.dart';

/// Contract for anything that can produce the advisor's next reply in a thread.
/// Swapping providers (OpenAI, Anthropic, a local model) only means providing
/// a new implementation — nothing above this layer needs to change.
abstract class ChatModelService {
  Future<String> generateReply({
    required Customer customer,
    required List<ChatMessage> history,
  });
}

/// Calls OpenAI's chat completions API, using the customer's lead details to
/// ground the reply as Meera Varma, the insurance advisor this app represents.
class OpenAiChatService implements ChatModelService {
  final String apiKey;
  final String model;
  final Uri _endpoint = Uri.parse('https://api.openai.com/v1/chat/completions');

  OpenAiChatService({required this.apiKey, this.model = 'gpt-4o-mini'});

  String _systemPrompt(Customer c) => '''
You are Meera Varma, an IRDAI-licensed home & life insurance advisor replying to a customer lead inside a chat app.
Lead context: name=${c.name}, need=${c.need}, location=${c.loc}, detail=${c.detail}, budget=${c.budget}, urgency=${c.urgency}, source=${c.via}.
Reply as Meera in 1-3 short, warm, professional sentences. Do not mention that you are an AI.
''';

  @override
  Future<String> generateReply({
    required Customer customer,
    required List<ChatMessage> history,
  }) async {
    final messages = [
      {'role': 'system', 'content': _systemPrompt(customer)},
      for (final m in history)
        {
          'role': m.kind == 'me' ? 'assistant' : 'user',
          'content': m.text,
        },
    ];

    final response = await http.post(
      _endpoint,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $apiKey',
      },
      body: jsonEncode({
        'model': model,
        'messages': messages,
        'max_tokens': 200,
        'temperature': 0.7,
      }),
    );

    if (response.statusCode != 200) {
      throw ChatModelException('OpenAI request failed (${response.statusCode}): ${response.body}');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final choices = data['choices'] as List<dynamic>?;
    String? content;
    if (choices != null && choices.isNotEmpty) {
      final message = choices.first['message'] as Map<String, dynamic>?;
      content = message?['content'] as String?;
    }
    if (content == null || content.trim().isEmpty) {
      throw const ChatModelException('OpenAI response had no content');
    }
    return content.trim();
  }
}

/// Canned fallback used when no API key is configured, so the app still runs
/// out of the box. Swapped for [OpenAiChatService] once OPENAI_API_KEY is set.
class MockChatService implements ChatModelService {
  const MockChatService();

  @override
  Future<String> generateReply({
    required Customer customer,
    required List<ChatMessage> history,
  }) async {
    await Future.delayed(const Duration(milliseconds: 900));
    return 'Thanks, that sounds good 👍';
  }
}

class ChatModelException implements Exception {
  final String message;
  const ChatModelException(this.message);
  @override
  String toString() => message;
}

import 'models/customer.dart';

List<Customer> buildCustomers() => [
      Customer(
        id: 'rs', ini: 'RS', name: 'Rahul S.', via: 'ChatGPT',
        need: 'Home insurance', status: LeadStatus.new_, unread: 1, time: '2 min',
        loc: 'Jubilee Hills', detail: '3BHK, just purchased', budget: '~₹8,000/yr',
        urgency: 'This week', lastMe: false,
        preview: 'Looking for home cover for a 3BHK I just…',
        quote: 'Looking for home cover for a 3BHK I just bought. What would premiums look like and can it be done this week?',
        thread: [
          ChatMessage('sys', 'Lead routed from ChatGPT · intake completed'),
          ChatMessage('them', 'Hi, I got your details from ChatGPT. Looking for home cover for a 3BHK I just bought.', '2:12'),
          ChatMessage('them', 'What would premiums look like, and can it be done this week?', '2:12'),
        ],
      ),
      Customer(
        id: 'ak', ini: 'AK', name: 'Anita K.', via: 'Perplexity',
        need: 'Term life · ₹1 Cr', status: LeadStatus.new_, unread: 1, time: '18 min',
        loc: 'Banjara Hills', detail: 'Non-smoker, age 34', budget: 'Best value',
        urgency: 'This month', lastMe: false,
        preview: 'Need a term life policy, around ₹1 crore…',
        quote: 'Need a term life policy, around ₹1 crore, non-smoker, age 34. Best options?',
        thread: [
          ChatMessage('sys', 'Lead routed from Perplexity · intake completed'),
          ChatMessage('them', 'Hi! Need a term life policy, around ₹1 crore, non-smoker, age 34.', '1:40'),
          ChatMessage('them', 'What are my best options?', '1:41'),
        ],
      ),
      Customer(
        id: 'sm', ini: 'SM', name: 'Sana M.', via: 'ChatGPT',
        need: 'Contents insurance', status: LeadStatus.new_, unread: 1, time: '40 min',
        loc: 'Gachibowli', detail: 'Rented apartment', budget: 'Low',
        urgency: 'Exploring', lastMe: false,
        preview: 'Contents insurance for a rented flat, is…',
        quote: 'Contents insurance for a rented apartment, is that a thing?',
        thread: [
          ChatMessage('sys', 'Lead routed from ChatGPT · intake completed'),
          ChatMessage('them', 'Contents insurance for a rented apartment — is that a thing?', '12:30'),
        ],
      ),
      Customer(
        id: 'nv', ini: 'NV', name: 'Naveen V.', via: 'Claude',
        need: 'Health cover · family', status: LeadStatus.active, unread: 0, time: '1 hr',
        loc: 'Kondapur', detail: 'Family of 4', budget: '₹25k/yr',
        urgency: 'This month', lastMe: true,
        preview: "You: I'd suggest a family floater. Shall I…",
        quote: 'Family floater health insurance for 4, budget ₹25k/year.',
        thread: [
          ChatMessage('sys', 'Lead routed from Claude · intake completed'),
          ChatMessage('them', 'Family floater health insurance for 4, budget ₹25k a year.', '11:00'),
          ChatMessage('me', "Happy to help! For a family of 4 I'd suggest a floater — better value than 4 individual policies.", '11:15'),
          ChatMessage('me', 'Shall I put together 2–3 options for you?', '11:16'),
        ],
      ),
      Customer(
        id: 'dp', ini: 'DP', name: 'Divya P.', via: 'ChatGPT',
        need: 'Motor renewal', status: LeadStatus.active, unread: 0, time: '3 hr',
        loc: 'Madhapur', detail: 'Car, cashless needed', budget: '—',
        urgency: 'This week', lastMe: true,
        preview: 'You: Here are 2 cashless options near you',
        quote: 'Car insurance renewal, want cashless garages near me.',
        thread: [
          ChatMessage('sys', 'Lead routed from ChatGPT · intake completed'),
          ChatMessage('them', 'Car insurance renewal due, want cashless garages near me.', '9:20'),
          ChatMessage('me', 'Here are 2 cashless options near you — both cover garages in Madhapur.', '9:35'),
        ],
      ),
      Customer(
        id: 'tp', ini: 'TP', name: 'Tej P.', via: 'Claude',
        need: 'Motor insurance', status: LeadStatus.won, unread: 0, time: 'Yesterday',
        loc: 'Jubilee Hills', detail: 'Car · policy issued', budget: '₹11,200',
        urgency: 'Done', lastMe: true,
        preview: 'You: Policy issued 🎉 sending documents',
        quote: 'Car insurance, cashless garages near me.',
        thread: [
          ChatMessage('sys', 'Lead routed from Claude · intake completed'),
          ChatMessage('them', 'Need car insurance with cashless garages nearby.', 'Mon'),
          ChatMessage('me', 'Sorted! Comprehensive cover, cashless network near you, ₹11,200.', 'Mon'),
          ChatMessage('me', 'Policy issued 🎉 sending documents now.', 'Yst'),
        ],
      ),
      Customer(
        id: 'rm', ini: 'RM', name: 'Ravi M.', via: 'Perplexity',
        need: 'Home insurance', status: LeadStatus.won, unread: 0, time: '3 days',
        loc: 'Banjara Hills', detail: 'Villa · policy issued', budget: '₹14,500',
        urgency: 'Done', lastMe: true,
        preview: 'You: Thanks Ravi, glad we got you covered',
        quote: 'Home insurance for a villa in Banjara Hills.',
        thread: [
          ChatMessage('sys', 'Lead routed from Perplexity · intake completed'),
          ChatMessage('them', 'Home insurance for my villa in Banjara Hills.', '3d'),
          ChatMessage('me', 'All done — villa comprehensive cover issued at ₹14,500. Thanks Ravi, glad we got you covered!', '3d'),
        ],
      ),
    ];

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

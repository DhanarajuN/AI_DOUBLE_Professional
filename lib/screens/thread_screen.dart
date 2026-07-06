import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models/customer.dart';
import '../viewmodels/thread_view_model.dart';
import '../widgets/common.dart';

class ThreadScreen extends StatefulWidget {
  const ThreadScreen({super.key});

  @override
  State<ThreadScreen> createState() => _ThreadScreenState();
}

class _ThreadScreenState extends State<ThreadScreen> {
  bool chatView = true;
  final _scrollCtrl = ScrollController();
  final _inputCtrl = TextEditingController();
  String? _lastShownError;

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(_scrollCtrl.position.maxScrollExtent,
            duration: const Duration(milliseconds: 200), curve: Curves.easeOut);
      }
    });
  }

  void _send(ThreadViewModel vm, [String? preset]) {
    final text = preset ?? _inputCtrl.text.trim();
    if (text.isEmpty) return;
    _inputCtrl.clear();
    vm.send(text);
    _scrollToBottom();
  }

  void _setStatus(ThreadViewModel vm, LeadStatus s) {
    vm.setStatus(s);
    ToastOverlay.show(context, 'Marked as ${s.label}');
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ThreadViewModel>();
    final c = vm.customer;

    if (vm.error != null && vm.error != _lastShownError) {
      _lastShownError = vm.error;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) ToastOverlay.show(context, vm.error!);
      });
    }

    _scrollToBottom();

    return Scaffold(
      backgroundColor: AppColors.app,
      body: Column(
        children: [
          AppBarBar(
            leading: IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.text, size: 20),
            ),
            title: Row(children: [
              InitialsAvatar(initials: c.ini, size: 40, fontSize: 15),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(c.name, overflow: TextOverflow.ellipsis,
                        style: AppText.body(size: 15.5, weight: FontWeight.w600)),
                    Text.rich(TextSpan(style: AppText.mono(size: 10, color: AppColors.faint), children: [
                      const TextSpan(text: 'via '),
                      TextSpan(text: c.via, style: AppText.mono(size: 10, color: AppColors.gold, weight: FontWeight.w500)),
                      TextSpan(text: ' · ${c.need}'),
                    ])),
                  ],
                ),
              ),
            ]),
            actions: [
              IconBtn(icon: Icons.call_outlined, onTap: () => ToastOverlay.show(context, 'Call customer')),
            ],
          ),
          // toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: const BoxDecoration(color: AppColors.panel, border: Border(bottom: BorderSide(color: AppColors.line))),
            child: Row(children: [
              Expanded(child: _toggleTab('Chat', Icons.chat_bubble_outline, chatView, () => setState(() => chatView = true))),
              Expanded(child: _toggleTab('Ticket', Icons.confirmation_number_outlined, !chatView, () => setState(() => chatView = false))),
            ]),
          ),
          Expanded(
            child: chatView ? _buildChat(vm) : _buildTicket(vm),
          ),
        ],
      ),
    );
  }

  Widget _toggleTab(String label, IconData icon, bool on, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(color: on ? AppColors.panel2 : Colors.transparent, borderRadius: BorderRadius.circular(9)),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(icon, size: 15, color: on ? AppColors.text : AppColors.dim),
          const SizedBox(width: 6),
          Text(label, style: AppText.body(size: 13, weight: FontWeight.w600, color: on ? AppColors.text : AppColors.dim)),
        ]),
      ),
    );
  }

  Widget _buildChat(ThreadViewModel vm) {
    final msgs = vm.messages;
    final c = vm.customer;
    return Column(
      children: [
        Expanded(
          child: Container(
            color: AppColors.chatBg,
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.fromLTRB(12, 14, 12, 4),
              itemCount: msgs.length + (vm.isTyping ? 1 : 0),
              itemBuilder: (ctx, i) {
                if (i >= msgs.length) return _typingBubble();
                return _bubble(msgs[i]);
              },
            ),
          ),
        ),
        if (c.status != LeadStatus.won)
          Container(
            color: AppColors.chatBg,
            padding: const EdgeInsets.fromLTRB(12, 7, 12, 3),
            child: Wrap(spacing: 7, runSpacing: 7, children: [
              _chip(vm, 'Send quote'),
              _chip(vm, 'Ask for details'),
              _chip(vm, 'Schedule call'),
            ]),
          ),
        Container(
          color: AppColors.panel,
          padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
          child: Row(children: [
            IconButton(
              onPressed: () => ToastOverlay.show(context, 'Attach / send quote'),
              icon: const Icon(Icons.add, color: AppColors.dim, size: 23),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.panel2,
                  border: Border.all(color: AppColors.line),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: TextField(
                  controller: _inputCtrl,
                  style: AppText.body(size: 14),
                  onSubmitted: (_) => _send(vm),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Reply to customer',
                    hintStyle: AppText.body(size: 14, color: AppColors.faint),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => _send(vm),
              child: Container(
                width: 42, height: 42,
                alignment: Alignment.center,
                decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_upward, color: Color(0xFF04120D), size: 19),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _chip(ThreadViewModel vm, String label) {
    return GestureDetector(
      onTap: () => _send(vm, label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.teal.withOpacity(.08),
          border: Border.all(color: AppColors.teal),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(label, style: AppText.body(size: 12.5, weight: FontWeight.w500, color: AppColors.teal)),
      ),
    );
  }

  Widget _bubble(ChatMessage m) {
    if (m.kind == 'sys') {
      return Align(
        alignment: Alignment.center,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(.1),
            border: Border.all(color: AppColors.gold.withOpacity(.2)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(m.text, textAlign: TextAlign.center, style: AppText.body(size: 10.5, color: AppColors.gold, weight: FontWeight.w500)),
        ),
      );
    }
    final me = m.kind == 'me';
    return Align(
      alignment: me ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3.5),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * .78),
        padding: const EdgeInsets.fromLTRB(11, 8, 11, 6),
        decoration: BoxDecoration(
          color: me ? AppColors.mine : AppColors.other,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(11),
            topRight: const Radius.circular(11),
            bottomLeft: Radius.circular(me ? 11 : 3),
            bottomRight: Radius.circular(me ? 3 : 11),
          ),
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(m.text, style: AppText.body(size: 14)),
          const SizedBox(height: 2),
          Text(m.time, style: AppText.body(size: 9.5, color: me ? Colors.white54 : AppColors.faint)),
        ]),
      ),
    );
  }

  Widget _typingBubble() {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 3.5),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
        decoration: BoxDecoration(color: AppColors.mine, borderRadius: BorderRadius.circular(11)),
        child: const SizedBox(width: 30, child: _TypingDots()),
      ),
    );
  }

  Widget _buildTicket(ThreadViewModel vm) {
    final c = vm.customer;
    return ListView(
      padding: const EdgeInsets.only(bottom: 10),
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 14),
          decoration: BoxDecoration(gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [AppColors.panel, AppColors.panel.withOpacity(0)])),
          child: Row(children: [
            InitialsAvatar(initials: c.ini, size: 52, radius: 14, fontSize: 18),
            const SizedBox(width: 13),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(c.name, style: AppText.display(size: 19)),
                const SizedBox(height: 2),
                Text('${c.need} · ${c.loc}', style: AppText.body(size: 12, color: AppColors.dim)),
              ]),
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 0, 18, 12),
          child: Row(children: [
            Expanded(child: _statusBtn(vm, 'New', LeadStatus.new_)),
            const SizedBox(width: 8),
            Expanded(child: _statusBtn(vm, 'In progress', LeadStatus.active)),
            const SizedBox(width: 8),
            Expanded(child: _statusBtn(vm, 'Won', LeadStatus.won, isWon: true)),
          ]),
        ),
        _ticketSection('What the customer asked', child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.panel,
              border: Border.fromBorderSide(BorderSide(color: AppColors.line)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(width: 3, color: AppColors.gold),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    child: Text('"${c.quote}"', style: AppText.body(size: 13.5, color: AppColors.text)),
                  ),
                ),
              ],
            ),
          ),
        )),
        _ticketSection('Parsed by AI', child: Column(children: [
          _kv('Service', c.need),
          _kv('Location', c.loc),
          _kv('Detail', c.detail),
          _kv('Budget', c.budget),
          _kv('Urgency', c.urgency),
          _kv('Source', 'via ${c.via}', last: true),
        ])),
        _ticketSection('Lead timeline', child: Column(children: [
          _timelineItem('Discovered via ${c.via}', 'Customer asked an AI assistant · ${c.time} ago'),
          _timelineItem('Intake completed', 'AI Double qualified & routed the lead to you'),
          _timelineItem(
            c.status == LeadStatus.new_ ? 'Awaiting your reply' : 'You responded',
            c.status == LeadStatus.new_ ? 'Reply to move this forward' : 'Conversation in progress',
            pending: c.status == LeadStatus.new_,
          ),
          _timelineItem(
            c.status == LeadStatus.won ? 'Won 🎉' : 'Convert to booking',
            c.status == LeadStatus.won ? 'Policy issued' : 'Mark as won when closed',
            pending: c.status != LeadStatus.won,
          ),
        ])),
        Padding(
          padding: const EdgeInsets.fromLTRB(18, 12, 18, 0),
          child: Wrap(spacing: 8, runSpacing: 8, children: [
            _actBtn('Reply in chat', hot: true, onTap: () => setState(() => chatView = true)),
            _actBtn('Create booking', onTap: () => ToastOverlay.show(context, 'Booking created')),
            _actBtn('Send quote', onTap: () => ToastOverlay.show(context, 'Quote sent')),
            _actBtn('Mark as won', onTap: () => _setStatus(vm, LeadStatus.won)),
          ]),
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget _statusBtn(ThreadViewModel vm, String label, LeadStatus s, {bool isWon = false}) {
    final on = vm.customer.status == s;
    final color = isWon ? AppColors.green : AppColors.gold;
    return GestureDetector(
      onTap: () => _setStatus(vm, s),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 9),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: on ? color.withOpacity(.12) : Colors.transparent,
          border: Border.all(color: on ? color.withOpacity(.3) : AppColors.line),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(label, style: AppText.body(size: 12, weight: FontWeight.w600, color: on ? color : AppColors.dim)),
      ),
    );
  }

  Widget _ticketSection(String title, {required Widget child}) {
    return Container(
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      decoration: const BoxDecoration(border: Border(top: BorderSide(color: AppColors.line))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: AppText.mono(size: 10, weight: FontWeight.w700, color: AppColors.faint, letterSpacing: .16)),
        const SizedBox(height: 10),
        child,
      ]),
    );
  }

  Widget _kv(String k, String v, {bool last = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(border: last ? null : const Border(bottom: BorderSide(color: AppColors.line))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(k, style: AppText.body(size: 13, color: AppColors.dim)),
        Text(v, style: AppText.body(size: 13, weight: FontWeight.w500)),
      ]),
    );
  }

  Widget _timelineItem(String title, String desc, {bool pending = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Container(
          margin: const EdgeInsets.only(top: 5, right: 10),
          width: 7, height: 7,
          decoration: BoxDecoration(
            color: pending ? AppColors.faint : AppColors.teal,
            shape: BoxShape.circle,
          ),
        ),
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: AppText.body(size: 13, weight: FontWeight.w600, color: pending ? AppColors.dim : AppColors.text)),
            const SizedBox(height: 1),
            Text(desc, style: AppText.body(size: 11.5, color: AppColors.faint)),
          ]),
        ),
      ]),
    );
  }

  Widget _actBtn(String label, {bool hot = false, required VoidCallback onTap}) {
    return SizedBox(
      width: 155,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: hot ? AppColors.teal : Colors.transparent,
          side: BorderSide(color: hot ? AppColors.teal : AppColors.line2),
          padding: const EdgeInsets.symmetric(vertical: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
        ),
        child: Text(label, style: AppText.body(size: 13.5, weight: FontWeight.w600, color: hot ? const Color(0xFF04120D) : AppColors.text)),
      ),
    );
  }
}

class _TypingDots extends StatefulWidget {
  const _TypingDots();
  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200))..repeat();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (ctx, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final t = (_ctrl.value + i * 0.15) % 1.0;
            final scale = t < .3 ? (1 - (t / .3) * .3) : .7 + ((1 - t) * .3).clamp(0, .3);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 6, height: 6,
              decoration: BoxDecoration(color: Colors.white.withOpacity(0.3 + scale.toDouble() * .5), shape: BoxShape.circle),
            );
          }),
        );
      },
    );
  }
}

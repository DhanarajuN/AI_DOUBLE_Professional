import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../data.dart';
import '../widgets/common.dart';
import '../viewmodels/profile_view_model.dart';
import '../viewmodels/calendar_view_model.dart';

/// Shared scaffold shell used by all pushed dashboard subpages (.push #s-sub)
class SubScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget body;
  final Widget? action;
  const SubScaffold({super.key, required this.title, required this.subtitle, required this.body, this.action});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.app,
      body: Column(children: [
        AppBarBar(
          leading: IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.text, size: 20),
          ),
          title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text(title, style: AppText.display()),
            Text(subtitle, style: AppText.mono(size: 10)),
          ]),
          actions: action != null ? [action!] : [],
        ),
        Expanded(child: body),
      ]),
    );
  }
}

// ============ SCORE ============
class ScoreScreen extends StatefulWidget {
  const ScoreScreen({super.key});
  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))..forward();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SubScaffold(
      title: 'Discoverability',
      subtitle: 'SCORE & KEY STATS',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AppColors.panel, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(18)),
            child: Column(children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Text('AI Discoverability Score', style: AppText.body(size: 13, weight: FontWeight.w600, color: AppColors.dim)),
                _pill('↑ 12 this week'),
              ]),
              const SizedBox(height: 16),
              AnimatedBuilder(
                animation: _ctrl,
                builder: (ctx, _) => ScoreRing(value: 84 * _ctrl.value, size: 170, strokeWidth: 12),
              ),
              const SizedBox(height: 16),
              Text('Highly discoverable', style: AppText.body(size: 15, weight: FontWeight.w600)),
              const SizedBox(height: 4),
              Text('Appearing in AI answers for 18 local queries this week.',
                  textAlign: TextAlign.center, style: AppText.body(size: 12.5, color: AppColors.dim)),
              const SizedBox(height: 12),
              Wrap(spacing: 8, alignment: WrapAlignment.center, children: [
                _assistChip('ChatGPT'), _assistChip('Claude'), _assistChip('Perplexity'),
              ]),
            ]),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.7,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _kpi('47', '↑ 31%', 'Leads this month'),
              _kpi('₹1.4L', '↑ 22%', 'Attributed revenue'),
              _kpi('4 min', null, 'Avg. response time'),
              _kpi('68%', null, 'Lead → consult rate'),
            ],
          ),
          const SubHead('Top queries you appear for'),
          _srcRow('"home insurance advisor near me"', '42'),
          _srcRow('"cheapest term life Hyderabad"', '31'),
          _srcRow('"how to claim home insurance"', '24'),
        ],
      ),
    );
  }

  Widget _pill(String text) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
        decoration: BoxDecoration(color: AppColors.goldDim, borderRadius: BorderRadius.circular(100)),
        child: Text(text, style: AppText.body(size: 11, weight: FontWeight.w600, color: AppColors.gold)),
      );

  Widget _assistChip(String name) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(color: AppColors.panel2, borderRadius: BorderRadius.circular(100)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(width: 6, height: 6, margin: const EdgeInsets.only(right: 6), decoration: const BoxDecoration(color: AppColors.teal, shape: BoxShape.circle)),
          Text(name, style: AppText.body(size: 11.5, weight: FontWeight.w500)),
        ]),
      );

  Widget _kpi(String n, String? up, String label) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: AppColors.panel, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(14)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
          Row(children: [
            Text(n, style: AppText.display(size: 20)),
            if (up != null) ...[const SizedBox(width: 6), Text(up, style: AppText.body(size: 11, weight: FontWeight.w600, color: AppColors.green))],
          ]),
          const SizedBox(height: 3),
          Text(label, style: AppText.body(size: 11.5, color: AppColors.dim)),
        ]),
      );

  Widget _srcRow(String q, String v) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(children: [
          Expanded(child: Text(q, style: AppText.body(size: 13, color: AppColors.dim))),
          Text(v, style: AppText.body(size: 13, weight: FontWeight.w600)),
        ]),
      );
}

/// Circular gradient progress ring used for the discoverability score.
class ScoreRing extends StatelessWidget {
  final double value; // 0-100
  final double size;
  final double strokeWidth;
  const ScoreRing({super.key, required this.value, this.size = 90, this.strokeWidth = 9});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size, height: size,
      child: Stack(alignment: Alignment.center, children: [
        CustomPaint(size: Size(size, size), painter: _RingPainter(value, strokeWidth)),
        Text(value.round().toString(), style: AppText.display(size: size * .26)),
      ]),
    );
  }
}

class _RingPainter extends CustomPainter {
  final double value;
  final double strokeWidth;
  _RingPainter(this.value, this.strokeWidth);

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = (size.width - strokeWidth) / 2;
    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(.07)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawCircle(center, radius, bgPaint);

    final fgPaint = Paint()
      ..shader = const LinearGradient(colors: [AppColors.teal, AppColors.gold]).createShader(Rect.fromCircle(center: center, radius: radius))
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final sweep = 2 * math.pi * (value / 100);
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -math.pi / 2, sweep, false, fgPaint);
  }

  @override
  bool shouldRepaint(covariant _RingPainter old) => old.value != value;
}

// ============ PROFILE ============
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileViewModel(),
      child: const _ProfileScreenBody(),
    );
  }
}

class _ProfileScreenBody extends StatelessWidget {
  const _ProfileScreenBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ProfileViewModel>();
    return SubScaffold(
      title: 'Profile & Knowledge',
      subtitle: 'WHAT THE AI KNOWS',
      action: IconButton(
        onPressed: () => ToastOverlay.show(context, 'Profile saved & AI re-published'),
        icon: const Icon(Icons.save_outlined, color: AppColors.dim, size: 21),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(children: [
            Text('Profile completeness', style: AppText.body(size: 13, color: AppColors.dim)),
            const Spacer(),
            Text('82%', style: AppText.body(size: 13, weight: FontWeight.w600, color: AppColors.gold)),
          ]),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: LinearProgressIndicator(
              value: .82, minHeight: 6, backgroundColor: AppColors.panel2,
              valueColor: const AlwaysStoppedAnimation(AppColors.gold),
            ),
          ),
          const SizedBox(height: 16),
          _editSection(vm, 'Identity', Icons.person_outline, [
            _field('Display name', 'Meera Varma'),
            _field('Tagline', 'Home & life insurance advisor · Gold'),
            _field('Area served', 'Jubilee Hills, Hyderabad'),
          ]),
          _editSection(vm, 'About', Icons.description_outlined, [
            _field('What the AI tells customers',
                'IRDAI-licensed advisor specialising in home, term-life and health cover for families. I compare 20+ insurers and handle claims end to end. First consultation is always free.',
                multiline: true),
          ]),
          _editSection(vm, 'Services', Icons.flash_on_outlined, [
            Wrap(spacing: 8, runSpacing: 8, children: [
              ...vm.services.map((s) => _chip(s, onRemove: () {
                    vm.removeService(s);
                    ToastOverlay.show(context, 'Service removed');
                  })),
              _addChip('+ Add', () => ToastOverlay.show(context, 'Add a service')),
            ]),
          ]),
          _editSection(vm, 'FAQs · answered by AI', Icons.help_outline, [
            ...kFaqs.map((f) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: AppColors.panel2, borderRadius: BorderRadius.circular(10)),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(f[0], style: AppText.body(size: 13, weight: FontWeight.w600)),
                      const SizedBox(height: 4),
                      Text(f[1], style: AppText.body(size: 12.5, color: AppColors.dim)),
                    ]),
                  ),
                )),
            _addChip('+ Add FAQ', () => ToastOverlay.show(context, 'Add an FAQ')),
          ]),
        ],
      ),
    );
  }

  Widget _editSection(ProfileViewModel vm, String title, IconData icon, List<Widget> children) {
    final open = vm.isOpen(title);
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(color: AppColors.panel, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(14)),
      child: Column(children: [
        InkWell(
          onTap: () => vm.toggleSection(title),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(children: [
              Icon(icon, size: 18, color: AppColors.teal),
              const SizedBox(width: 10),
              Expanded(child: Text(title, style: AppText.body(size: 14, weight: FontWeight.w600))),
              AnimatedRotation(
                turns: open ? 0.25 : 0,
                duration: const Duration(milliseconds: 200),
                child: const Icon(Icons.chevron_right, size: 18, color: AppColors.dim),
              ),
            ]),
          ),
        ),
        if (open)
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
          ),
      ]),
    );
  }

  Widget _field(String label, String value, {bool multiline = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label, style: AppText.body(size: 11.5, color: AppColors.dim)),
        const SizedBox(height: 4),
        TextField(
          controller: TextEditingController(text: value),
          maxLines: multiline ? 3 : 1,
          style: AppText.body(size: 13.5),
          decoration: InputDecoration(
            filled: true,
            fillColor: AppColors.panel2,
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: AppColors.line)),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(9), borderSide: const BorderSide(color: AppColors.line)),
          ),
        ),
      ]),
    );
  }

  Widget _chip(String label, {required VoidCallback onRemove}) {
    return Container(
      padding: const EdgeInsets.only(left: 12, right: 6, top: 6, bottom: 6),
      decoration: BoxDecoration(color: AppColors.panel2, borderRadius: BorderRadius.circular(100)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Text(label, style: AppText.body(size: 12.5)),
        const SizedBox(width: 4),
        GestureDetector(onTap: onRemove, child: const Icon(Icons.close, size: 14, color: AppColors.faint)),
      ]),
    );
  }

  Widget _addChip(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(border: Border.all(color: AppColors.line2), borderRadius: BorderRadius.circular(100)),
        child: Text(label, style: AppText.body(size: 12.5, color: AppColors.dim)),
      ),
    );
  }
}

// ============ CALENDAR ============
class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CalendarViewModel(),
      child: const _CalendarScreenBody(),
    );
  }
}

class _CalendarScreenBody extends StatelessWidget {
  const _CalendarScreenBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CalendarViewModel>();
    final selDay = vm.selectedDay;
    final appts = vm.appointmentsForSelectedDay;
    return SubScaffold(
      title: 'Calendar',
      subtitle: 'CONSULTS & BOOKINGS',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('July 2026', style: AppText.display(size: 18)),
          const SizedBox(height: 12),
          Row(children: ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map((d) => Expanded(child: Center(child: Text(d, style: AppText.body(size: 11, color: AppColors.faint)))))
              .toList()),
          const SizedBox(height: 6),
          GridView.count(
            crossAxisCount: 7,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              ...List.generate(3, (_) => const SizedBox()),
              ...List.generate(31, (i) {
                final d = i + 1;
                final has = kAppts.containsKey(d);
                final today = d == 5;
                final sel = d == selDay;
                return GestureDetector(
                  onTap: () => vm.selectDay(d),
                  child: Container(
                    margin: const EdgeInsets.all(2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: sel ? AppColors.teal : (today ? AppColors.panel2 : Colors.transparent),
                      shape: BoxShape.circle,
                      border: today && !sel ? Border.all(color: AppColors.teal) : null,
                    ),
                    child: Stack(alignment: Alignment.center, children: [
                      Text('$d', style: AppText.body(size: 13, weight: FontWeight.w500, color: sel ? const Color(0xFF04120D) : AppColors.text)),
                      if (has)
                        Positioned(
                          bottom: 2,
                          child: Container(width: 4, height: 4, decoration: BoxDecoration(color: sel ? const Color(0xFF04120D) : AppColors.gold, shape: BoxShape.circle)),
                        ),
                    ]),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 16),
          Text('$selDay July${selDay == 5 ? ' · Today' : ''}', style: AppText.body(size: 15, weight: FontWeight.w600)),
          const SizedBox(height: 10),
          if (appts == null)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Text('No appointments this day.', style: AppText.body(size: 13.5, color: AppColors.faint)),
            )
          else
            ...appts.map((a) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.panel, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(12)),
                  child: Row(children: [
                    Container(
                      width: 54,
                      alignment: Alignment.center,
                      child: Text(a[0], style: AppText.mono(size: 12, weight: FontWeight.w600, color: AppColors.gold)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text(a[1], style: AppText.body(size: 13.5, weight: FontWeight.w600)),
                        Text(a[2], style: AppText.body(size: 12, color: AppColors.dim)),
                      ]),
                    ),
                  ]),
                )),
        ],
      ),
    );
  }
}

// ============ ANALYTICS ============
class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 700))..forward();
  final months = const ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul'];
  final values = const [120, 145, 138, 170, 190, 210, 247];
  final sources = const [
    ['ChatGPT', 112, .46],
    ['Perplexity', 64, .26],
    ['Claude', 48, .19],
    ['Gemini', 23, .09],
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final maxV = 260.0;
    return SubScaffold(
      title: 'Analytics',
      subtitle: 'DISCOVERY SOURCES',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.panel, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Leads · last 7 months', style: AppText.mono(size: 10, color: AppColors.faint)),
              const SizedBox(height: 6),
              Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Text('247', style: AppText.display(size: 30)),
                const SizedBox(width: 8),
                Padding(padding: const EdgeInsets.only(bottom: 5), child: Text('↑ 34% YoY', style: AppText.body(size: 11.5, weight: FontWeight.w600, color: AppColors.green))),
              ]),
              const SizedBox(height: 16),
              AnimatedBuilder(
                animation: _ctrl,
                builder: (ctx, _) => SizedBox(
                  height: 120,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: values.asMap().entries.map((e) {
                      final isLast = e.key == values.length - 1;
                      final h = (e.value / maxV) * 120 * _ctrl.value;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Container(
                            height: h,
                            decoration: BoxDecoration(
                              color: isLast ? AppColors.gold : AppColors.teal.withOpacity(.55),
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 6),
              Row(children: months.map((m) => Expanded(child: Center(child: Text(m, style: AppText.body(size: 10, color: AppColors.faint))))).toList()),
            ]),
          ),
          const SubHead('Leads by AI assistant'),
          ...sources.map((s) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                child: Row(children: [
                  SizedBox(width: 78, child: Text(s[0] as String, style: AppText.body(size: 12.5, color: AppColors.dim))),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: LinearProgressIndicator(
                        value: s[2] as double, minHeight: 7, backgroundColor: AppColors.panel2,
                        valueColor: const AlwaysStoppedAnimation(AppColors.teal),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(width: 28, child: Text('${s[1]}', textAlign: TextAlign.right, style: AppText.body(size: 12.5, weight: FontWeight.w600))),
                ]),
              )),
        ],
      ),
    );
  }
}

// ============ BILLING ============
class BillingScreen extends StatelessWidget {
  const BillingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SubScaffold(
      title: 'Plan & Billing',
      subtitle: 'YOUR SUBSCRIPTION',
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.panel, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(16)),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Current plan', style: AppText.mono(size: 10, color: AppColors.faint)),
              const SizedBox(height: 4),
              Text('Gold', style: AppText.display(size: 22, color: AppColors.gold)),
              Text('\$15/month · renews 2 Aug 2026', style: AppText.body(size: 12.5, color: AppColors.dim)),
              const SizedBox(height: 12),
              _row('Priority ranking', 'Active'),
              _row('Lead dashboard & analytics', 'Active'),
              _row('Leads this month', '47 · unlimited'),
            ]),
          ),
          const SubHead('Upgrade for more'),
          _planCard(
            context, 'Professional', '\$49', '/mo',
            ['Everything in Gold', 'Lead routing + CRM', 'WhatsApp & email campaigns', 'Calendar sync'],
            ctaLabel: 'Upgrade to Professional', hot: true,
          ),
          _planCard(
            context, 'Enterprise', 'Custom', '',
            ['Multiple locations & staff', 'Custom AI agent', 'API + MCP integration', 'White label'],
            ctaLabel: 'Talk to sales', hot: false,
          ),
        ],
      ),
    );
  }

  Widget _row(String k, String v) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text(k, style: AppText.body(size: 12.5, color: AppColors.dim)),
          Text(v, style: AppText.body(size: 12.5, weight: FontWeight.w500)),
        ]),
      );

  Widget _planCard(BuildContext context, String name, String price, String suffix, List<String> features,
      {required String ctaLabel, required bool hot}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: AppColors.panel, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(16)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(name.toUpperCase(), style: AppText.mono(size: 11, color: AppColors.dim, letterSpacing: .14)),
        const SizedBox(height: 8),
        Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
          Text(price, style: AppText.display(size: 26)),
          if (suffix.isNotEmpty) Text(suffix, style: AppText.body(size: 13, color: AppColors.dim)),
        ]),
        const SizedBox(height: 12),
        ...features.map((f) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  margin: const EdgeInsets.only(top: 3, right: 8),
                  width: 15, height: 15,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.goldDim, shape: BoxShape.circle),
                  child: const Icon(Icons.check, size: 9, color: AppColors.gold),
                ),
                Expanded(child: Text(f, style: AppText.body(size: 13))),
              ]),
            )),
        const SizedBox(height: 4),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => ToastOverlay.show(context, hot ? 'Upgrade to Professional' : 'Contact sales'),
            style: OutlinedButton.styleFrom(
              backgroundColor: hot ? AppColors.teal : Colors.transparent,
              side: BorderSide(color: hot ? AppColors.teal : AppColors.line2),
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(11)),
            ),
            child: Text(ctaLabel, style: AppText.body(size: 14, weight: FontWeight.w600, color: hot ? const Color(0xFF04120D) : AppColors.text)),
          ),
        ),
      ]),
    );
  }
}

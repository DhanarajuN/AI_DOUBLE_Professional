import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../theme.dart';
import '../models/customer.dart';
import '../repositories/lead_repository.dart';
import '../viewmodels/chats_list_view_model.dart';
import '../viewmodels/thread_view_model.dart';
import '../services/chat_model_service.dart';
import '../widgets/common.dart';
import 'thread_screen.dart';

class ChatsScreen extends StatelessWidget {
  const ChatsScreen({super.key});

  void _openThread(BuildContext context, ChatsListViewModel vm, Customer c) async {
    vm.openThread(c.id);
    await Navigator.of(context).push(_SlidePageRoute(
      child: ChangeNotifierProvider(
        create: (ctx) => ThreadViewModel(
          customerId: c.id,
          repository: ctx.read<LeadRepository>(),
          chatService: ctx.read<ChatModelService>(),
        ),
        child: const ThreadScreen(),
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ChatsListViewModel>();
    // Rebuild when the underlying lead data changes (new messages, status, etc.)
    final repository = context.watch<LeadRepository>();

    if (!repository.loaded) {
      return const Center(child: CircularProgressIndicator(color: AppColors.teal));
    }

    return Column(
      children: [
        AppBarBar(
          leading: const BrandMark(),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Text('AI ', style: AppText.display()),
                Text('Double', style: AppText.display().copyWith(fontStyle: FontStyle.italic, color: AppColors.gold, fontWeight: FontWeight.w400)),
              ]),
              Text('MEERA · INSURANCE ADVISOR', style: AppText.mono(size: 10)),
            ],
          ),
          actions: [
            IconBtn(icon: Icons.search, onTap: () => ToastOverlay.show(context, 'Search')),
            IconBtn(
              icon: Icons.notifications_none,
              dot: repository.unreadCount > 0,
              onTap: () => ToastOverlay.show(
                context,
                repository.unreadCount > 0 ? '${repository.unreadCount} new notifications' : 'No new notifications',
              ),
            ),
          ],
        ),
        // status strip
        Container(
          decoration: const BoxDecoration(
            color: AppColors.line,
            border: Border(bottom: BorderSide(color: AppColors.line)),
          ),
          child: Row(
            children: [
              _statCell('${vm.countFor('new')}', 'New leads', AppColors.gold, () => vm.setFilter('new')),
              _divider(),
              _statCell('${vm.countFor('active')}', 'In progress', AppColors.text, () => vm.setFilter('active')),
              _divider(),
              _statCell('${vm.countFor('won')}', 'Won', AppColors.green, () => vm.setFilter('won')),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // search bar
              Padding(
                padding: const EdgeInsets.all(10).copyWith(left: 14, right: 14),
                child: GestureDetector(
                  onTap: () => ToastOverlay.show(context, 'Search chats'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.panel2,
                      border: Border.all(color: AppColors.line),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(children: [
                      const Icon(Icons.search, size: 16, color: AppColors.faint),
                      const SizedBox(width: 9),
                      Text('Search customers…', style: AppText.body(size: 13.5, color: AppColors.faint)),
                    ]),
                  ),
                ),
              ),
              // filter pills
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  children: [
                    _pill(vm, 'All', 'all'),
                    _pill(vm, 'New', 'new'),
                    _pill(vm, 'In progress', 'active'),
                    _pill(vm, 'Won', 'won'),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              ...vm.filtered.map((c) => _ChatRow(customer: c, onTap: () => _openThread(context, vm, c))),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _divider() => Container(width: 1, color: AppColors.line);

  Widget _statCell(String n, String l, Color color, VoidCallback onTap) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Container(
          color: AppColors.app,
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 8),
          child: Column(children: [
            Text(n, style: AppText.display(size: 19, color: color)),
            const SizedBox(height: 1),
            Text(l, style: AppText.body(size: 10, color: AppColors.dim)),
          ]),
        ),
      ),
    );
  }

  Widget _pill(ChatsListViewModel vm, String label, String key) {
    final on = vm.filter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 7, top: 2, bottom: 8),
      child: GestureDetector(
        onTap: () => vm.setFilter(key),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 6),
          decoration: BoxDecoration(
            color: on ? AppColors.text : Colors.transparent,
            border: Border.all(color: on ? AppColors.text : AppColors.line2),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Text(label, style: AppText.body(size: 12.5, weight: FontWeight.w500, color: on ? AppColors.ink : AppColors.dim)),
        ),
      ),
    );
  }
}

class _ChatRow extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;
  const _ChatRow({required this.customer, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final c = customer;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InitialsAvatar(initials: c.ini),
            const SizedBox(width: 12),
            Expanded(
              child: Container(
                padding: const EdgeInsets.only(bottom: 11),
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: AppColors.line)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Row(children: [
                            Flexible(
                              child: Text(c.name, overflow: TextOverflow.ellipsis,
                                  style: AppText.body(size: 15.5, weight: FontWeight.w600, letterSpacing: -.01)),
                            ),
                            const SizedBox(width: 6),
                            StatusPill(status: c.status),
                          ]),
                        ),
                        Text(c.time, style: AppText.body(size: 11, color: c.unread > 0 ? AppColors.green : AppColors.faint)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        if (c.lastMe) const Text('✓✓ ', style: TextStyle(color: AppColors.green, fontSize: 12)),
                        Expanded(
                          child: Text(c.preview, maxLines: 1, overflow: TextOverflow.ellipsis,
                              style: AppText.body(size: 13, color: AppColors.dim)),
                        ),
                        if (c.unread > 0)
                          Container(
                            margin: const EdgeInsets.only(left: 8),
                            width: 20, height: 20,
                            alignment: Alignment.center,
                            decoration: const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
                            child: Text('${c.unread}', style: const TextStyle(color: Color(0xFF04120D), fontSize: 11, fontWeight: FontWeight.w700)),
                          ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text.rich(
                      TextSpan(
                        style: AppText.mono(size: 10, color: AppColors.faint, letterSpacing: .03),
                        children: [
                          const TextSpan(text: 'via '),
                          TextSpan(text: c.via, style: AppText.mono(size: 10, color: AppColors.gold, weight: FontWeight.w500)),
                          TextSpan(text: ' · ${c.need}'),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Slide-in-from-right push transition to mirror the .push CSS transform.
class _SlidePageRoute<T> extends PageRoute<T> {
  final Widget child;
  _SlidePageRoute({required this.child});

  @override
  Color? get barrierColor => null;
  @override
  bool get barrierDismissible => false;
  @override
  String? get barrierLabel => null;
  @override
  bool get maintainState => true;
  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  @override
  Widget buildPage(context, animation, secondaryAnimation) => child;

  @override
  Widget buildTransitions(context, animation, secondaryAnimation, child) {
    final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
    return SlideTransition(
      position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(curved),
      child: child,
    );
  }
}

/// Exported so other screens (More tab) can reuse the same transition.
Route<T> slideRoute<T>(Widget child) => _SlidePageRoute<T>(child: child);

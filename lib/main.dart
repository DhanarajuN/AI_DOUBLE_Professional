import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'repositories/lead_repository.dart';
import 'services/chat_model_service.dart';
import 'viewmodels/app_view_model.dart';
import 'viewmodels/chats_list_view_model.dart';
import 'screens/chats_screen.dart';
import 'screens/more_screen.dart';

/// Set at build/run time, e.g. `flutter run --dart-define=OPENAI_API_KEY=sk-...`.
/// Falls back to a canned mock reply when no key is provided, so the app
/// still runs out of the box.
const _openAiApiKey = String.fromEnvironment('OPENAI_API_KEY');

void main() => runApp(const AiDoubleApp());

class AiDoubleApp extends StatelessWidget {
  const AiDoubleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LeadRepository()..load()),
        Provider<ChatModelService>(
          create: (_) => _openAiApiKey.isEmpty ? const MockChatService() : OpenAiChatService(apiKey: _openAiApiKey),
        ),
        ChangeNotifierProvider(create: (_) => AppViewModel()),
        ChangeNotifierProxyProvider<LeadRepository, ChatsListViewModel>(
          create: (ctx) => ChatsListViewModel(ctx.read<LeadRepository>()),
          update: (ctx, repo, previous) => previous ?? ChatsListViewModel(repo),
        ),
      ],
      child: MaterialApp(
        title: 'AI Double — Pro Chats',
        debugShowCheckedModeBanner: false,
        theme: buildAppTheme(),
        home: const AppShell(),
      ),
    );
  }
}

class AppShell extends StatelessWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final appVm = context.watch<AppViewModel>();
    final newCount = context.watch<LeadRepository>().newLeadCount;

    return Scaffold(
      backgroundColor: AppColors.app,
      body: SafeArea(
        top: false,
        child: IndexedStack(
          index: appVm.tab,
          children: const [
            ChatsScreen(),
            MoreScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          color: AppColors.panel,
          border: Border(top: BorderSide(color: AppColors.line)),
        ),
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).padding.bottom),
        child: Row(
          children: [
            Expanded(child: _navBtn(context, 0, Icons.chat_bubble_outline, 'Chats', appVm, badge: newCount > 0 ? '$newCount' : null)),
            Expanded(child: _navBtn(context, 1, Icons.grid_view_rounded, 'Dashboard', appVm)),
          ],
        ),
      ),
    );
  }

  Widget _navBtn(BuildContext context, int idx, IconData icon, String label, AppViewModel appVm, {String? badge}) {
    final on = appVm.tab == idx;
    return InkWell(
      onTap: () => appVm.setTab(idx),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 9),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Stack(clipBehavior: Clip.none, children: [
            Icon(icon, size: 22, color: on ? AppColors.teal : AppColors.faint),
            if (badge != null)
              Positioned(
                top: -6, right: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  height: 15, alignment: Alignment.center,
                  decoration: BoxDecoration(color: AppColors.gold, borderRadius: BorderRadius.circular(100)),
                  child: Text(badge, style: const TextStyle(color: Color(0xFF1A1206), fontSize: 9, fontWeight: FontWeight.w700)),
                ),
              ),
          ]),
          const SizedBox(height: 3),
          Text(label, style: AppText.body(size: 10, weight: FontWeight.w500, color: on ? AppColors.teal : AppColors.faint)),
        ]),
      ),
    );
  }
}

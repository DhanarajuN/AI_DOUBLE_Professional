import 'package:flutter/material.dart';
import '../theme.dart';
import '../widgets/common.dart';
import 'chats_screen.dart' show slideRoute;
import 'sub_screens.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBarBar(
          title: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
            Text('Dashboard', style: AppText.display()),
            Text('YOUR AI DOUBLE', style: AppText.mono(size: 10)),
          ]),
          actions: [
            IconBtn(icon: Icons.settings_outlined, onTap: () => ToastOverlay.show(context, 'Settings')),
          ],
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  const InitialsAvatar(initials: 'MV', size: 54),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Text('Meera Varma', style: AppText.display(size: 18)),
                        const SizedBox(width: 6),
                        const Text('✓', style: TextStyle(color: AppColors.teal, fontSize: 14)),
                      ]),
                      Text('Home & life insurance advisor', style: AppText.body(size: 12.5, color: AppColors.dim)),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(color: AppColors.goldDim, borderRadius: BorderRadius.circular(100)),
                        child: Text('Gold tier', style: AppText.body(size: 10.5, weight: FontWeight.w600, color: AppColors.gold)),
                      ),
                    ]),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
              GestureDetector(
                onTap: () => Navigator.of(context).push(slideRoute(const ScoreScreen())),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(color: AppColors.panel, border: Border.all(color: AppColors.line), borderRadius: BorderRadius.circular(16)),
                  child: Row(children: [
                    const ScoreRing(value: 84, size: 64, strokeWidth: 7),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        Text('Highly discoverable', style: AppText.body(size: 13.5, weight: FontWeight.w600)),
                        const SizedBox(height: 2),
                        Text('Appearing for 18 local AI queries', style: AppText.body(size: 11.5, color: AppColors.dim)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(color: AppColors.goldDim, borderRadius: BorderRadius.circular(100)),
                          child: Text('↑ 12 this week', style: AppText.body(size: 10, weight: FontWeight.w600, color: AppColors.gold)),
                        ),
                      ]),
                    ),
                  ]),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(children: [
                  const SizedBox(height: 8),
                  MenuItemRow(
                    icon: Icons.bar_chart, title: 'Discoverability & stats', subtitle: 'Score, leads, revenue',
                    onTap: () => Navigator.of(context).push(slideRoute(const ScoreScreen())),
                  ),
                  MenuItemRow(
                    icon: Icons.description_outlined, title: 'Profile & Knowledge', subtitle: 'What the AI knows about you',
                    badge: '82%',
                    onTap: () => Navigator.of(context).push(slideRoute(const ProfileScreen())),
                  ),
                  MenuItemRow(
                    icon: Icons.calendar_today_outlined, title: 'Calendar', subtitle: 'Consults & bookings',
                    onTap: () => Navigator.of(context).push(slideRoute(const CalendarScreen())),
                  ),
                  MenuItemRow(
                    icon: Icons.show_chart, title: 'Analytics', subtitle: 'Where discovery comes from',
                    onTap: () => Navigator.of(context).push(slideRoute(const AnalyticsScreen())),
                  ),
                  MenuItemRow(
                    icon: Icons.credit_card_outlined, title: 'Plan & Billing', subtitle: 'Gold · \$15/mo',
                    onTap: () => Navigator.of(context).push(slideRoute(const BillingScreen())),
                  ),
                ]),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

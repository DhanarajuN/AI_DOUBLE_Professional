import 'package:flutter/material.dart';
import '../theme.dart';
import '../models/customer.dart';

/// Top bar used across screens (.bar)
class AppBarBar extends StatelessWidget {
  final Widget? leading;
  final Widget title;
  final List<Widget> actions;
  const AppBarBar({super.key, this.leading, required this.title, this.actions = const []});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: 14, right: 14, top: 14 + MediaQuery.of(context).padding.top, bottom: 12,
      ),
      decoration: const BoxDecoration(
        color: AppColors.panel,
        border: Border(bottom: BorderSide(color: AppColors.line)),
      ),
      child: Row(
        children: [
          if (leading != null) ...[leading!, const SizedBox(width: 11)],
          Expanded(child: title),
          ...actions,
        ],
      ),
    );
  }
}

class IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool dot;
  const IconBtn({super.key, required this.icon, required this.onTap, this.dot = false});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, color: AppColors.dim, size: 21),
          if (dot)
            Positioned(
              top: -1, right: -1,
              child: Container(
                width: 8, height: 8,
                decoration: BoxDecoration(
                  color: AppColors.gold,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.panel, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Mark logo (.mark) - teal square with a gold dot
class BrandMark extends StatelessWidget {
  const BrandMark({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 32, height: 32,
          decoration: BoxDecoration(
            gradient: AppColors.tealGradient,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 18),
        ),
        Positioned(
          bottom: -2, right: -2,
          child: Container(
            width: 8, height: 8,
            decoration: BoxDecoration(
              color: AppColors.gold,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.panel, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}

/// Avatar circle with initials + teal gradient (.cav / .cbav / .tkav)
class InitialsAvatar extends StatelessWidget {
  final String initials;
  final double size;
  final double radius;
  final double fontSize;
  const InitialsAvatar({super.key, required this.initials, this.size = 50, this.radius = 100, this.fontSize = 17});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size, height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        gradient: AppColors.tealGradient,
        borderRadius: BorderRadius.circular(radius > 50 ? size / 2 : radius),
      ),
      child: Text(
        initials,
        style: AppText.body(size: fontSize, weight: FontWeight.w600, color: Colors.white),
      ),
    );
  }
}

/// Status label pill (.slb)
class StatusPill extends StatelessWidget {
  final LeadStatus status;
  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final (bg, fg) = switch (status) {
      LeadStatus.new_ => (AppColors.goldDim, AppColors.gold),
      LeadStatus.active => (AppColors.blue.withOpacity(.12), AppColors.blue),
      LeadStatus.won => (AppColors.green.withOpacity(.12), AppColors.green),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(100)),
      child: Text(
        status.label.toUpperCase(),
        style: AppText.body(size: 9, weight: FontWeight.w700, color: fg, letterSpacing: .04),
      ),
    );
  }
}

/// Section header used in dashboard subpages (.subhead)
class SubHead extends StatelessWidget {
  final String text;
  const SubHead(this.text, {super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
      child: Text(text, style: AppText.mono(size: 10, weight: FontWeight.w700, color: AppColors.faint, letterSpacing: .16)),
    );
  }
}

/// Bottom toast (.toast)
class ToastOverlay {
  static OverlayEntry? _entry;

  static void show(BuildContext context, String message) {
    _entry?.remove();
    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (ctx) => Positioned(
        left: 0, right: 0, bottom: 100,
        child: Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 11),
              decoration: BoxDecoration(
                color: const Color(0xFF1A2B24),
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: AppColors.line2),
                boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 30, offset: Offset(0, 10))],
              ),
              child: Text(message, style: AppText.body(size: 13, weight: FontWeight.w500)),
            ),
          ),
        ),
      ),
    );
    _entry = entry;
    overlay.insert(entry);
    Future.delayed(const Duration(milliseconds: 2200), () {
      if (_entry == entry) {
        entry.remove();
        _entry = null;
      }
    });
  }
}

/// A generic tappable menu row for the dashboard (.menu-item)
class MenuItemRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? badge;
  final VoidCallback onTap;
  const MenuItemRow({super.key, required this.icon, required this.title, required this.subtitle, this.badge, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.line)),
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(color: AppColors.panel2, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppColors.teal, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppText.body(size: 14.5, weight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: AppText.body(size: 12.5, color: AppColors.dim)),
                ],
              ),
            ),
            if (badge != null) ...[
              Container(
                margin: const EdgeInsets.only(right: 6),
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                decoration: BoxDecoration(color: AppColors.panel2, borderRadius: BorderRadius.circular(100)),
                child: Text(badge!, style: AppText.body(size: 11, weight: FontWeight.w600, color: AppColors.dim)),
              ),
            ],
            const Icon(Icons.chevron_right, color: AppColors.faint, size: 20),
          ],
        ),
      ),
    );
  }
}

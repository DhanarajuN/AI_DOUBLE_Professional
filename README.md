# AI Double — Pro Chats (Flutter)

Flutter port of `professional.html` — a dark teal/gold "AI Double" app for a
professional (insurance advisor) to manage AI-routed customer leads.

## Structure

```
lib/
  main.dart              # App root + AppShell (bottom nav: Chats / Dashboard)
  theme.dart              # Colors + text styles ported from the CSS :root vars
  data.dart               # Mock data (customers, services, FAQs, appointments)
  models/customer.dart    # Customer + ChatMessage models, LeadStatus enum
  widgets/common.dart     # Shared bits: app bar, avatars, status pill, toast, menu row
  screens/
    chats_screen.dart     # Leads inbox (status strip, search, filter pills, list)
    thread_screen.dart    # Customer thread: Chat/Ticket toggle, bubbles, composer
    more_screen.dart       # Dashboard hub (profile header, score ring, menu)
    sub_screens.dart       # Score, Profile & Knowledge, Calendar, Analytics, Billing
```

## What was mapped

| HTML/CSS/JS concept                  | Flutter equivalent                              |
|---------------------------------------|--------------------------------------------------|
| `:root` CSS variables                 | `AppColors` / `AppText` in `theme.dart`          |
| `.screen.tab` (Chats / More)          | `IndexedStack` + bottom nav in `AppShell`        |
| `.push` slide-in subpages             | `Navigator.push` with a custom slide `PageRoute` |
| `CUSTOMERS` array                     | `List<Customer>` from `data.dart`                |
| Chat bubbles (`.bub.me/.them`)        | `_bubble()` in `thread_screen.dart`              |
| Ticket view / status buttons          | `_buildTicket()` in `thread_screen.dart`         |
| Score ring SVG                        | Custom `ScoreRing` (CustomPainter arc)           |
| Analytics bar chart                   | Animated `Container` bars in `AnalyticsScreen`   |
| Toasts                                | `ToastOverlay.show(context, message)`            |

## Running it

```bash
flutter pub get
flutter run
```

Fonts (Fraunces, Inter Tight, JetBrains Mono) are loaded via `google_fonts`,
so the first run needs network access to fetch them (or bundle them locally
under `assets/fonts` and switch to `fontFamily` if you need fully offline builds).

## Notes / things you may want to extend

- Data is in-memory only (mirrors the original demo, which had no backend).
- The "attach" and "search" actions just show a toast, same as the HTML demo.
- The calendar is a static demo month (July 2026) matching the source.
- If you want true edge-to-edge phone-frame preview like the HTML's centered
  420px mock, just run on a phone-sized simulator — the layout is responsive.

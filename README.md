# moyu (iOS)

`moyu` is a SwiftUI iPhone app that turns life expectancy data into a blunt daily countdown. It stays fully offline, stores everything locally, and shares data with a home screen widget through an app group.

## Current Feature Set
- Countdown based on birth date and biological sex using a fixed CDC 2022 life expectancy baseline.
- "Days left" and "bonus days" modes, depending on whether the estimated date has passed.
- Life checklist feature with local persistence, completion tracking, and a minimal `3/10` progress indicator on the main screen.
- Daily rotating quotes with built-in translations for English, Simplified Chinese, Spanish, and Japanese.
- Three-step onboarding for profile, language, and notification permission.
- Settings screen for editing profile data, language, and reminder time.
- Local notifications scheduled on weekdays only.
- Background refresh task that periodically rebuilds the notification queue.
- WidgetKit extension with `systemSmall` and `systemMedium` widgets.
- Fully offline persistence via `UserDefaults` in the shared app group `group.com.aetherrim.moyuapp`.

## Platform
- iPhone only
- iOS 18.0+
- Xcode 16+
- SwiftUI + WidgetKit + BackgroundTasks + UserNotifications

## Project Layout
```text
Shared/
├── CoreModels.swift          # Language enum, life expectancy config, countdown calculator, date bounds
├── LifeChecklistItem.swift   # Codable life checklist item model
├── QuoteRepository.swift     # 100 localized quotes + deterministic quote-of-the-day selection
├── DailyQuoteProvider.swift  # Per-day quote caching wrapper
└── SharedDefaults.swift      # Shared app-group defaults keys and migration

moyu/
├── AppState.swift            # Persistent app state, widget reloads, notification coordination
├── BackgroundRefreshManager.swift
├── NotificationManager.swift
├── ContentView.swift         # Switches between onboarding and main experience
├── OnboardingView.swift      # Profile, language, notifications
├── CountdownView.swift       # Main countdown screen
├── LifeChecklistView.swift   # Add/toggle/delete life checklist items
├── SettingsView.swift        # Editable profile/language/notification settings
├── moyuApp.swift             # App entry point
├── Assets.xcassets/
├── Base.lproj/
├── en.lproj/
├── es.lproj/
├── ja.lproj/
└── zh-Hans.lproj/

moyuWidget/
├── moyuWidget.swift          # Widget timeline, widget views, shared-data loading
└── moyuWidget.entitlements

moyuTests/                    # Xcode Testing template, currently minimal
moyuUITests/                  # Basic UI test templates
```

## How It Works
- `AppState` is the single source of truth for selected language, birth date, biological sex, onboarding state, reminder settings, and life checklist items.
- `CountdownCalculator` derives the estimated death date from the fixed baseline in `Shared/CoreModels.swift`.
- `LifeChecklistItem` entries are encoded into shared `UserDefaults`, and `AppState` derives the completed/total progress string shown on the main screen.
- `QuoteRepository` picks a deterministic quote for each calendar day, anchored from `2024-01-01`.
- `NotificationManager` clears and rebuilds pending reminder requests, scheduling the next 40 weekdays at the chosen time.
- `BackgroundRefreshManager` registers `com.aetherrim.moyuapp.notification-refresh` and resubmits the refresh request so reminders stay populated.
- The widget reads the same shared defaults and renders either a compact ring or a medium card with countdown progress and the daily quote.

## Getting Started
1. Open `moyu.xcodeproj` in Xcode.
2. Select the `moyu` scheme and run on an iOS 18 simulator or device.
3. Complete onboarding: choose profile values, choose a language, and optionally allow notifications.
4. Add the widget from the iOS widget gallery if you want the home screen view.

## Configuration Notes
- The app and widget both depend on the app group `group.com.aetherrim.moyuapp`.
- If you fork this project under a different Apple developer account, update the bundle identifiers, app group, and entitlements together.
- Notification delivery depends on user permission and iOS background scheduling behavior.

## Data and Privacy
- No network calls
- No analytics
- No third-party dependencies
- User profile data and life checklist items are persisted locally in shared app-group `UserDefaults`
- All persisted data stays on-device

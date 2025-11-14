# Quiet Quitting Today (iOS)

Quiet Quitting Today is a lightweight SwiftUI app that turns life expectancy data into a daily reminder to guard your time. The app focuses on a delightful countdown, bilingual copy, and fully offline privacy.

## What You Get
- **Death Countdown** – Enter birth date and biological sex to see days left (or bonus days if you beat the odds).
- **Daily Quotes** – Rotating humor-filled Chinese/English lines to keep the tone light.
- **Local Reminders** – A single daily notification with your quote, configurable time or disable entirely.
- **Onboarding + Settings** – Minimal wizard for first launch, full editing afterward.
- **Localization** – Simplified Chinese and English across UI and content.
- **No Network, No Tracking** – Everything persists locally via `UserDefaults`.

## Project Layout
```
moyu/
├── CoreModels.swift        # Pure data types, life expectancy config, countdown calculator
├── AppState.swift          # ObservableObject: persistence, scheduling, onboarding state
├── QuoteRepository.swift   # Deterministic daily quote selection
├── NotificationManager.swift # UNUserNotificationCenter wrapper
├── CountdownView.swift     # Main screen with countdown + quote + quick actions
├── OnboardingView.swift    # Three-step intro for language, profile, notifications
├── SettingsView.swift      # Form-based editing for all preferences
├── ContentView.swift       # Root switch between onboarding and countdown
├── moyuApp.swift           # App entry point, injects AppState & locale
├── Base.lproj/Localizable.strings
├── en.lproj/Localizable.strings
└── zh-Hans.lproj/Localizable.strings
```

### Architecture Notes
- **State Management**: A single `AppState` observable object holds user choices, computes countdown, and schedules notifications. Views share it via `@EnvironmentObject`.
- **Domain Isolation**: Calculations and constants live in `CoreModels.swift`; side-effect helpers (quotes, notifications) are standalone structs so they can be swapped or tested.
- **SwiftUI-first**: All screens are pure SwiftUI; the root `ContentView` decides between onboarding and the main experience.
- **Persistence**: `UserDefaults` stores primitives, avoiding external dependencies. Notification scheduling updates whenever relevant settings change.

## Getting Started
1. Open `moyu.xcodeproj` in Xcode 16 or newer.
2. Build & run the `moyu` scheme on iOS 16+ simulator or device.
3. Step through onboarding: choose language, provide birth date & sex, allow notifications if desired.
4. Enjoy the real-time countdown; visit Settings to tweak reminders or information anytime.

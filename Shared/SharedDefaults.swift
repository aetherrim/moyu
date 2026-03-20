import Foundation

enum SharedDefaults {
    static let appGroupId = "group.com.aetherrim.moyuapp"

    static var userDefaults: UserDefaults {
        UserDefaults(suiteName: appGroupId) ?? .standard
    }

    static func migrateIfNeeded() {
        guard let sharedDefaults = UserDefaults(suiteName: appGroupId) else { return }
        guard !sharedDefaults.bool(forKey: Keys.didMigrateToAppGroup) else { return }

        let standard = UserDefaults.standard
        let keysToMigrate = [
            Keys.language,
            Keys.sex,
            Keys.birthDate,
            Keys.notificationEnabled,
            Keys.notificationTime,
            Keys.hasCompletedOnboarding
        ]

        for key in keysToMigrate {
            if sharedDefaults.object(forKey: key) == nil,
               let value = standard.object(forKey: key) {
                sharedDefaults.set(value, forKey: key)
            }
        }

        sharedDefaults.set(true, forKey: Keys.didMigrateToAppGroup)
    }
}

extension SharedDefaults {
    enum Keys {
        static let language = "settings.language"
        static let sex = "settings.sex"
        static let birthDate = "settings.birthDate"
        static let notificationEnabled = "settings.notificationEnabled"
        static let notificationTime = "settings.notificationTime"
        static let hasCompletedOnboarding = "settings.onboardingComplete"
        static let didMigrateToAppGroup = "settings.didMigrateToAppGroup"
    }
}

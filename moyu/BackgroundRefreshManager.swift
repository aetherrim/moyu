import BackgroundTasks
import Foundation

@MainActor
final class BackgroundRefreshManager {
    static let shared = BackgroundRefreshManager()
    static let taskIdentifier = "com.aetherrim.moyuapp.notification-refresh"

    private weak var appState: AppState?
    private var isRegistered = false
    private var refreshTask: Task<Bool, Never>?

    private init() {}

    func configure(appState: AppState) {
        self.appState = appState
        registerIfNeeded()
    }

    func schedule() {
        let request = BGAppRefreshTaskRequest(identifier: Self.taskIdentifier)
        request.earliestBeginDate = Calendar.current.date(byAdding: .day, value: 3, to: Date())

        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Failed to submit app refresh task: \(error)")
        }
    }

    private func registerIfNeeded() {
        guard !isRegistered else { return }

        isRegistered = BGTaskScheduler.shared.register(forTaskWithIdentifier: Self.taskIdentifier, using: nil) { task in
            guard let refreshTask = task as? BGAppRefreshTask else {
                task.setTaskCompleted(success: false)
                return
            }

            Task { @MainActor in
                await self.handle(refreshTask)
            }
        }
    }

    private func handle(_ task: BGAppRefreshTask) async {
        schedule()

        refreshTask?.cancel()
        let refreshTask = Task { [weak self] in
            guard let self, let appState = self.appState else { return false }
            await appState.refreshNotificationsFromBackground()
            return !Task.isCancelled
        }
        self.refreshTask = refreshTask

        task.expirationHandler = {
            refreshTask.cancel()
        }

        let success = await refreshTask.value
        task.setTaskCompleted(success: success)
        self.refreshTask = nil
    }
}

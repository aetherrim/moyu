import Foundation

struct LifeChecklistItem: Identifiable, Codable, Equatable {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var createdAt: Date
    var completedAt: Date?
    var sortOrder: Int

    init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        createdAt: Date = Date(),
        completedAt: Date? = nil,
        sortOrder: Int
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.completedAt = completedAt
        self.sortOrder = sortOrder
    }
}

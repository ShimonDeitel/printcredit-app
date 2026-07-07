import Foundation

struct PrintJob: Identifiable, Codable, Equatable {
    var id: UUID = UUID()
    var createdAt: Date = Date()
    var job: String
    var pages: Int
    var course: String

    init(id: UUID = UUID(), createdAt: Date = Date(), job: String, pages: Int, course: String) {
        self.id = id
        self.createdAt = createdAt
        self.job = job
        self.pages = pages
        self.course = course
    }
}

import Foundation
import Combine

@MainActor
final class Store: ObservableObject {
    static let freeLimit = 25

    @Published var items: [PrintJob] = []
    @Published var isPro: Bool = false

    private let fileURL: URL

    init() {
        let dir = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
        self.fileURL = dir.appendingPathComponent("printcredit_items.json")
        load()
    }

    var canAddMore: Bool {
        isPro || items.count < Store.freeLimit
    }

    func add(_ item: PrintJob) {
        items.append(item)
        save()
    }

    func update(_ item: PrintJob) {
        guard let idx = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[idx] = item
        save()
    }

    func delete(at offsets: IndexSet) {
        items.remove(atOffsets: offsets)
        save()
    }

    func delete(_ item: PrintJob) {
        items.removeAll { $0.id == item.id }
        save()
    }

    func load() {
        guard let data = try? Data(contentsOf: fileURL) else {
            items = seedData()
            save()
            return
        }
        if let decoded = try? JSONDecoder().decode([PrintJob].self, from: data) {
            items = decoded
        } else {
            items = seedData()
        }
    }

    func save() {
        if let data = try? JSONEncoder().encode(items) {
            try? data.write(to: fileURL)
        }
    }

    private func seedData() -> [PrintJob] {
        [
        PrintJob(job: "Sample Job 1", pages: 1, course: "Sample Course 1"),
        PrintJob(job: "Sample Job 2", pages: 2, course: "Sample Course 2"),
        PrintJob(job: "Sample Job 3", pages: 3, course: "Sample Course 3")
        ]
    }
}

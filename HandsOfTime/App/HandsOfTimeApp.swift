import SwiftData
import SwiftUI

@main
struct HandsOfTimeApp: App {
    init() {
        prepareApplicationSupportDirectory()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: PuzzleHistoryEntry.self)
    }

    private func prepareApplicationSupportDirectory() {
        guard let applicationSupportURL = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else {
            return
        }

        do {
            try FileManager.default.createDirectory(
                at: applicationSupportURL,
                withIntermediateDirectories: true
            )
        } catch {
            assertionFailure("Unable to create Application Support directory: \(error)")
        }
    }
}

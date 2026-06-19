import SwiftData
import SwiftUI

@main
struct HandsOfTimeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: PuzzleHistoryEntry.self)
    }
}

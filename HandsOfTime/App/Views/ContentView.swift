import SwiftUI

struct ContentView: View {
    @State private var tipJarStore = TipJarStore()

    var body: some View {
        TabView {
            NavigationStack {
                SolverView()
            }
            .tabItem {
                Label("Solve", systemImage: "clock")
            }

            NavigationStack {
                HistoryView()
            }
            .tabItem {
                Label("History", systemImage: "clock.arrow.circlepath")
            }

            NavigationStack {
                TipJarView(store: tipJarStore)
            }
            .tabItem {
                Label("Tip Jar", systemImage: "heart")
            }
        }
        .task {
            await tipJarStore.loadProducts()
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: PuzzleHistoryEntry.self, inMemory: true)
}

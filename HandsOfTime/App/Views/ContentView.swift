import SwiftUI

struct ContentView: View {
    var subscriptionStore: SubscriptionStore

    @State private var isShowingSettings = false

    var body: some View {
        ZStack {
            AppSpaceBackground()
                .ignoresSafeArea()

            NavigationStack {
                SolverView()
                    .toolbar {
                        settingsToolbarItem()
                    }
            }
            .cosmicNavigationChrome()
        }
        .preferredColorScheme(.dark)
        .task {
            await subscriptionStore.loadOfferings()
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsSheetView(subscriptionStore: subscriptionStore)
                .padModalSheetPresentation()
        }
    }

    @ToolbarContentBuilder
    private func settingsToolbarItem() -> some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            Button {
                isShowingSettings = true
            } label: {
                Image(systemName: "gearshape")
            }
            .accessibilityLabel("Settings")
        }
    }
}

private struct SettingsSheetView: View {
    let subscriptionStore: SubscriptionStore
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            SettingsView(subscriptionStore: subscriptionStore)
        }
        .cosmicNavigationChrome()
    }
}

private extension View {
    func cosmicNavigationChrome() -> some View {
        toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    ContentView(subscriptionStore: SubscriptionStore())
        .modelContainer(for: PuzzleHistoryEntry.self, inMemory: true)
}

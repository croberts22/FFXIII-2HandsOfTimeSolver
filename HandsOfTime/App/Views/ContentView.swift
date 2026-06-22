import SwiftUI

struct ContentView: View {
    @State private var tipJarStore = TipJarStore()
    @State private var isShowingSettings = false

    var body: some View {
        ZStack {
            AppSpaceBackground()
                .ignoresSafeArea()

            TabView {
                NavigationStack {
                    SolverView()
                        .toolbar {
                            settingsToolbarItem()
                        }
                }
                .cosmicNavigationChrome()
                .tabItem {
                    Label("Solve", systemImage: "clock")
                }

                NavigationStack {
                    HistoryView()
                        .toolbar {
                            settingsToolbarItem()
                        }
                }
                .cosmicNavigationChrome()
                .tabItem {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            }
            .background(.clear)
            .toolbarBackground(.hidden, for: .tabBar)
        }
        .preferredColorScheme(.dark)
        .task {
            await tipJarStore.loadProducts()
        }
        .sheet(isPresented: $isShowingSettings) {
            NavigationStack {
                SettingsView(tipJarStore: tipJarStore)
            }
            .cosmicNavigationChrome()
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

private extension View {
    func cosmicNavigationChrome() -> some View {
        toolbarBackground(.hidden, for: .navigationBar)
    }
}

#Preview {
    ContentView()
        .modelContainer(for: PuzzleHistoryEntry.self, inMemory: true)
}

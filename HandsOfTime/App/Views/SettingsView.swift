import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    let tipJarStore: TipJarStore

    var body: some View {
        List {
            Section {
                NavigationLink {
                    TipJarView(store: tipJarStore)
                } label: {
                    Label("Tip Jar", systemImage: "heart")
                }
            }
            .listRowBackground(Color.clear)

            Section("History") {
                NavigationLink {
                    HistoryView()
                } label: {
                    Label("History", systemImage: "clock.arrow.circlepath")
                }
            }
            .listRowBackground(Color.clear)

            Section {
                NavigationLink {
                    SettingsPlaceholderView(
                        title: "Privacy Policy",
                        systemImage: "lock.shield"
                    )
                } label: {
                    Label("Privacy Policy", systemImage: "lock.shield")
                }

                NavigationLink {
                    SettingsPlaceholderView(
                        title: "Terms of Use",
                        systemImage: "doc.text"
                    )
                } label: {
                    Label("Terms of Use", systemImage: "doc.text")
                }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .scrollContentBackground(.hidden)
        .toolbarBackground(.hidden, for: .navigationBar)
        .background {
            AppSpaceBackground()
                .ignoresSafeArea()
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
}

private struct SettingsPlaceholderView: View {
    let title: String
    let systemImage: String

    var body: some View {
        ContentUnavailableView(
            title,
            systemImage: systemImage,
            description: Text("Coming soon.")
        )
        .navigationTitle(title)
        .toolbarBackground(.hidden, for: .navigationBar)
        .background {
            AppSpaceBackground()
                .ignoresSafeArea()
        }
    }
}

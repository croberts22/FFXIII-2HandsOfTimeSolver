import SwiftUI

private enum LegalDocumentURL {
    static let privacyPolicy = URL(string: "https://spacepyro.com/handsoftimesolver/privacy-policy/")!
    static let termsOfUse = URL(string: "https://spacepyro.com/handsoftimesolver/terms-of-use/")!
}

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var subscriptionStore: SubscriptionStore

    var body: some View {
        List {
            Section("Support") {
                NavigationLink {
                    TipJarView(store: subscriptionStore)
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
                Link(destination: LegalDocumentURL.privacyPolicy) {
                    Label("Privacy Policy", systemImage: "lock.shield")
                }

                Link(destination: LegalDocumentURL.termsOfUse) {
                    Label("Terms of Use", systemImage: "doc.text")
                }
            }
            .listRowBackground(Color.clear)
        }
        .listStyle(.insetGrouped)
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
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

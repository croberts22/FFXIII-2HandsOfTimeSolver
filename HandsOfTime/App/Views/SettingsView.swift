import SafariServices
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
            Section {
                AppInfoHeaderView()
                    .listRowInsets(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                    .listRowBackground(Color.clear)
            }

            NavigationLink {
                TipJarView(store: subscriptionStore)
            } label: {
                Label("Tip Jar", systemImage: "heart")
            }
            .listRowBackground(Color.clear)

            NavigationLink {
                HistoryView()
            } label: {
                Label("History", systemImage: "clock.arrow.circlepath")
            }
            .listRowBackground(Color.clear)

            NavigationLink {
                SafariView(url: LegalDocumentURL.privacyPolicy)
            } label: {
                Label("Privacy Policy", systemImage: "lock.shield")
            }
            .listRowBackground(Color.clear)

            NavigationLink {
                SafariView(url: LegalDocumentURL.termsOfUse)
            } label: {
                Label("Terms of Use", systemImage: "doc.text")
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

private struct SafariView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

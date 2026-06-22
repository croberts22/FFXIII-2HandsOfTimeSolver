import RevenueCat
import SwiftUI

struct TipJarView: View {
    var store: SubscriptionStore

    var body: some View {
        List {
            Section {
                Text("The Hands of Time solver is fully usable without purchases. However, if you feel like this app has helped you get through these rather tedious puzzles, a tip would be greatly appreciated! Tips are entirely optional and don't impact the use of this app in any way.")
                    .foregroundStyle(.primary)
            }
            .listRowBackground(Color.clear)

            Section("Support me with...") {
                if store.isLoading, store.availablePackages.isEmpty {
                    HStack {
                        Spacer()
                        ProgressView()
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                } else if store.availablePackages.isEmpty {
                    Text("Mog searched everywhere, kupo, but no tip offerings have turned up in this timeline!")
                        .foregroundStyle(.secondary)
                        .listRowBackground(Color.clear)
                } else {
                    ForEach(store.availablePackages, id: \.identifier) { package in
                        TipProductRow(
                            package: package,
                            isPurchasing: store.purchasingPackageID == package.identifier
                        ) {
                            Task {
                                await store.purchase(package)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }

            if let statusMessage = store.statusMessage {
                Section {
                    Text(statusMessage)
                        .foregroundStyle(.secondary)
                }
                .listRowBackground(Color.clear)
            }
        }
        .navigationTitle("Tip Jar")
        .scrollContentBackground(.hidden)
        .background {
            AppSpaceBackground()
                .ignoresSafeArea()
        }
        .refreshable {
            await store.loadOfferings()
        }
    }
}

private struct TipProductRow: View {
    let package: Package
    let isPurchasing: Bool
    let purchase: () -> Void

    private var product: StoreProduct {
        package.storeProduct
    }

    var body: some View {
        Button(action: purchase) {
            HStack(spacing: 12) {
                Image(systemName: "heart")
                    .foregroundStyle(.secondary)
                    .frame(width: 28)

                VStack(alignment: .leading, spacing: 4) {
                    Text(product.localizedTitle)
                        .font(.headline)
                        .foregroundStyle(.primary)

                    if !product.localizedDescription.isEmpty {
                        Text(product.localizedDescription)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }

                Spacer()

                if isPurchasing {
                    ProgressView()
                } else {
                    Text(product.localizedPriceString)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .disabled(isPurchasing)
        .accessibilityLabel("\(product.localizedTitle), \(product.localizedPriceString)")
        .accessibilityHint("Opens the purchase screen.")
    }
}

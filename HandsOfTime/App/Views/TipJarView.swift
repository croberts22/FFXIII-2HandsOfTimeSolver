import StoreKit
import SwiftUI

struct TipJarView: View {
    var store: TipJarStore

    var body: some View {
        List {
            Section {
                Text("Hands of Time is fully usable without purchases. Tips are optional one-time support tiers.")
                    .foregroundStyle(.secondary)
            }

            Section("Support") {
                ForEach(TipTier.allCases) { tier in
                    TipTierRow(
                        tier: tier,
                        product: store.product(for: tier),
                        isPurchased: store.isPurchased(tier.productID),
                        isLoading: store.isLoading
                    ) { product in
                        Task {
                            await store.purchase(product)
                        }
                    }
                }
            }

            Section {
                Button {
                    Task {
                        await store.restorePurchases()
                    }
                } label: {
                    Label("Restore Purchases", systemImage: "arrow.clockwise")
                }
                .disabled(store.isLoading)
            }

            if let statusMessage = store.statusMessage {
                Section {
                    Text(statusMessage)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .navigationTitle("Tip Jar")
        .refreshable {
            await store.loadProducts()
        }
    }
}

private struct TipTierRow: View {
    let tier: TipTier
    let product: Product?
    let isPurchased: Bool
    let isLoading: Bool
    let purchase: (Product) -> Void

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: isPurchased ? "heart.fill" : "heart")
                .foregroundStyle(isPurchased ? .pink : .secondary)
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(product?.displayName ?? tier.title)
                    .font(.headline)

                Text(product?.description ?? "Pending StoreKit setup")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            if let product, !isPurchased {
                Button(product.displayPrice) {
                    purchase(product)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isLoading)
            } else if isPurchased {
                Text("Purchased")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.green)
            } else {
                ProgressView()
                    .opacity(isLoading ? 1 : 0)
            }
        }
        .accessibilityElement(children: .combine)
    }
}

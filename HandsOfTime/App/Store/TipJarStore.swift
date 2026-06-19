import Foundation
import Observation
import StoreKit

enum TipTier: String, CaseIterable, Identifiable {
    case small
    case medium
    case large
    case generous
    case legendary

    var id: String { productID }

    var title: String {
        switch self {
        case .small:
            "Small Tip"
        case .medium:
            "Medium Tip"
        case .large:
            "Large Tip"
        case .generous:
            "Generous Tip"
        case .legendary:
            "Legendary Tip"
        }
    }

    var productID: String {
        switch self {
        case .small:
            "com.coreyroberts.ffxiii2solver.tip.099"
        case .medium:
            "com.coreyroberts.ffxiii2solver.tip.199"
        case .large:
            "com.coreyroberts.ffxiii2solver.tip.499"
        case .generous:
            "com.coreyroberts.ffxiii2solver.tip.999"
        case .legendary:
            "com.coreyroberts.ffxiii2solver.tip.1499"
        }
    }
}

@MainActor
@Observable
final class TipJarStore {
    private(set) var products: [Product] = []
    private(set) var purchasedProductIDs: Set<String> = []
    private(set) var isLoading = false
    var statusMessage: String?

    private var productIDs: Set<String> {
        Set(TipTier.allCases.map(\.productID))
    }

    func loadProducts() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let fetchedProducts = try await Product.products(for: Array(productIDs))
            products = fetchedProducts.sorted { first, second in
                tierIndex(for: first.id) < tierIndex(for: second.id)
            }
            await refreshPurchasedProducts()
            if products.isEmpty {
                statusMessage = "Tip products are not configured yet."
            }
        } catch {
            statusMessage = "Could not load tip products."
        }
    }

    func product(for tier: TipTier) -> Product? {
        products.first { $0.id == tier.productID }
    }

    func isPurchased(_ productID: String) -> Bool {
        purchasedProductIDs.contains(productID)
    }

    func purchase(_ product: Product) async {
        statusMessage = nil

        do {
            let result = try await product.purchase()
            switch result {
            case let .success(.verified(transaction)):
                purchasedProductIDs.insert(transaction.productID)
                await transaction.finish()
                statusMessage = "Thanks for the support."
            case .success(.unverified):
                statusMessage = "The purchase could not be verified."
            case .pending:
                statusMessage = "The purchase is pending."
            case .userCancelled:
                break
            @unknown default:
                statusMessage = "The purchase could not be completed."
            }
        } catch {
            statusMessage = "The purchase could not be completed."
        }
    }

    func restorePurchases() async {
        statusMessage = nil

        do {
            try await AppStore.sync()
            await refreshPurchasedProducts()
            statusMessage = purchasedProductIDs.isEmpty ? "No previous tips found." : "Purchases restored."
        } catch {
            statusMessage = "Could not restore purchases."
        }
    }

    func refreshPurchasedProducts() async {
        var purchasedIDs: Set<String> = []

        for await result in Transaction.currentEntitlements {
            guard case let .verified(transaction) = result else {
                continue
            }

            if productIDs.contains(transaction.productID) {
                purchasedIDs.insert(transaction.productID)
            }
        }

        purchasedProductIDs = purchasedIDs
    }

    private func tierIndex(for productID: String) -> Int {
        TipTier.allCases.firstIndex { $0.productID == productID } ?? Int.max
    }
}

import Foundation
import Observation
import RevenueCat

enum SubscriptionStoreError: LocalizedError {
    case noOfferingAvailable
    case packageNotFound
    case purchaseFailed(String)

    var errorDescription: String? {
        switch self {
        case .noOfferingAvailable:
            "No products are available right now. Check your RevenueCat offering setup."
        case .packageNotFound:
            "That product could not be found."
        case let .purchaseFailed(message):
            message
        }
    }
}

@MainActor
@Observable
final class SubscriptionStore: NSObject, PurchasesDelegate {
    private(set) var customerInfo: CustomerInfo?
    private(set) var currentOffering: Offering?
    private(set) var isLoading = false
    private(set) var purchasingPackageID: String?
    var statusMessage: String?
    var lastError: SubscriptionStoreError?

    var availablePackages: [Package] {
        guard let currentOffering else { return [] }

        return currentOffering.availablePackages.sorted {
            $0.storeProduct.price < $1.storeProduct.price
        }
    }

    override init() {
        super.init()
        Purchases.shared.delegate = self
    }

    func refreshCustomerInfo() async {
        do {
            customerInfo = try await Purchases.shared.customerInfo()
            lastError = nil
        } catch {
            lastError = .purchaseFailed(error.localizedDescription)
            statusMessage = "Could not refresh account information."
        }
    }

    func loadOfferings() async {
        isLoading = true
        defer { isLoading = false }

        statusMessage = nil
        lastError = nil

        do {
            let offerings = try await Purchases.shared.offerings()
            currentOffering = offerings.current ?? offerings.offering(
                identifier: RevenueCatConfiguration.defaultOfferingIdentifier
            )

            await refreshCustomerInfo()

            if currentOffering == nil {
                statusMessage = "Tip products are not configured yet."
                lastError = .noOfferingAvailable
            } else if availablePackages.isEmpty {
                statusMessage = "No products were found in the current offering."
            }
        } catch {
            statusMessage = "Could not load products."
            lastError = .purchaseFailed(error.localizedDescription)
        }
    }

    func purchase(_ package: Package) async {
        statusMessage = nil
        lastError = nil
        purchasingPackageID = package.identifier
        defer { purchasingPackageID = nil }

        do {
            let result = try await Purchases.shared.purchase(package: package)
            customerInfo = result.customerInfo

            if result.userCancelled {
                return
            }

            statusMessage = thankYouMessage(for: package)
        } catch let error as ErrorCode {
            switch error {
            case .purchaseCancelledError:
                break
            default:
                let message = error.localizedDescription
                lastError = .purchaseFailed(message)
                statusMessage = "The purchase could not be completed."
            }
        } catch {
            lastError = .purchaseFailed(error.localizedDescription)
            statusMessage = "The purchase could not be completed."
        }
    }

    nonisolated func purchases(_: Purchases, receivedUpdated customerInfo: CustomerInfo) {
        Task { @MainActor in
            self.customerInfo = customerInfo
        }
    }

    private func thankYouMessage(for package: Package) -> String {
        switch package.identifier {
        case "tipjar1":
            "Mog chirps his thanks, kupo! Even the smallest gesture helps keep the clock turning."
        case "tipjar2":
            "Yeul sees countless moments; in this one, your kindness stands apart. Thank you for the glimpse."
        case "tipjar3":
            "Serah never stopped believing the timeline could be set right. Your resolve keeps that same hope alive, thank you."
        case "tipjar4":
            "Noel knows what it means to carry a promise across time. Consider yours received. Thank you for the support."
        case "tipjar5":
            "Lightning doesn't offer praise lightly. Judgment rendered: worthy. Thank you, it means more than you know."
        default:
            "Thank you. You've turned the hands in our favor."
        }
    }
}

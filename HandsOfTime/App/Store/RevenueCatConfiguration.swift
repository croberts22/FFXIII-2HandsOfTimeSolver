import Foundation

enum RevenueCatConfiguration {
    /// RevenueCat entitlement identifier used for backend product configuration only.
    /// Tips do not unlock app features.
    static let supportEntitlementIdentifier = "FFXIII-2 Hands of Time Solver"

    /// Default offering identifier. RevenueCat uses `current` when this is `default`.
    static let defaultOfferingIdentifier = "default"

    /// Use the Test Store key for Debug builds only. Never ship Release builds with a Test Store key.
    static var apiKey: String {
        #if DEBUG
            "test_xhLuxVJjgRqkBTVYVJqxgTDJOMd"
        #else
            "appl_LhwcFhZYCNyfRtslXSzLjReJHGz"
        #endif
    }
}

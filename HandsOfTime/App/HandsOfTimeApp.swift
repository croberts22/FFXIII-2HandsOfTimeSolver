import SwiftData
import Sentry

import SwiftUI

@main
struct HandsOfTimeApp: App {
    init() {
        SentrySDK.start { options in
            options.dsn = "https://0283981197da349be7287869d992541e@o4509200644505600.ingest.us.sentry.io/4511607287578624"

            // Adds IP for users.
            // For more information, visit: https://docs.sentry.io/platforms/apple/data-management/data-collected/
            options.sendDefaultPii = false

            // Set tracesSampleRate to 1.0 to capture 100% of transactions for performance monitoring.
            // We recommend adjusting this value in production.
            options.tracesSampleRate = 0.1

            // Configure profiling. Visit https://docs.sentry.io/platforms/apple/profiling/ to learn more.
            options.configureProfiling = {
                $0.sessionSampleRate = 0.1 // We recommend adjusting this value in production.
                $0.lifecycle = .trace
            }

            // Uncomment the following lines to add more data to your events
            // options.attachScreenshot = true // This adds a screenshot to the error events
            // options.attachViewHierarchy = true // This adds the view hierarchy to the error events
            
            // Enable experimental logging features
            options.experimental.enableLogs = false
        }

        prepareApplicationSupportDirectory()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: PuzzleHistoryEntry.self)
    }

    private func prepareApplicationSupportDirectory() {
        guard let applicationSupportURL = FileManager.default.urls(
            for: .applicationSupportDirectory,
            in: .userDomainMask
        ).first else {
            return
        }

        do {
            try FileManager.default.createDirectory(
                at: applicationSupportURL,
                withIntermediateDirectories: true
            )
        } catch {
            assertionFailure("Unable to create Application Support directory: \(error)")
        }
    }
}

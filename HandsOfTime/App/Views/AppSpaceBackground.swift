import SwiftUI

struct AppSpaceBackground: View {
    var body: some View {
        Canvas { context, size in
            AppSpaceScene.drawBackground(context: &context, size: size)
        }
        .accessibilityHidden(true)
    }
}

enum AppSpacePalette {
    static let colors = [
        Color(red: 0.02, green: 0.03, blue: 0.08),
        Color(red: 0.0, green: 0.12, blue: 0.16),
        Color(red: 0.01, green: 0.01, blue: 0.03)
    ]
}

enum AppSpaceScene {
    static func drawBackground(
        context: inout GraphicsContext,
        size: CGSize,
        starCount: Int? = nil,
        starOpacity: Double? = nil
    ) {
        let rect = CGRect(origin: .zero, size: size)
        context.fill(
            Path(rect),
            with: .linearGradient(
                Gradient(colors: AppSpacePalette.colors),
                startPoint: CGPoint(x: rect.minX, y: rect.minY),
                endPoint: CGPoint(x: rect.maxX, y: rect.maxY)
            )
        )

        let resolvedStarCount = starCount ?? max(64, min(180, Int((size.width * size.height) / 6500)))
        for index in 0 ..< resolvedStarCount {
            let x = size.width * CGFloat((index * 37) % 101) / 101
            let y = size.height * CGFloat((index * 53) % 97) / 97
            let radius = CGFloat(index % 3 + 1) * 0.6
            let opacity = starOpacity ?? (0.18 + Double((index * 11) % 7) * 0.035)
            context.fill(
                Path(ellipseIn: CGRect(x: x, y: y, width: radius, height: radius)),
                with: .color(.white.opacity(opacity))
            )
        }
    }
}

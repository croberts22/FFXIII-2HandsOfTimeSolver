import HandsOfTimeCore
import SwiftUI

struct PuzzleRingView: View {
    let solution: HandsOfTimeSolution
    let stepIndex: Int
    let reduceMotion: Bool

    private var activeNode: Int? {
        guard stepIndex < solution.path.count else {
            return nil
        }
        return solution.path[stepIndex]
    }

    private var nextNode: Int? {
        guard stepIndex < solution.steps.count else {
            return nil
        }
        return solution.steps[stepIndex].nextIndex
    }

    private var completedNodes: Set<Int> {
        Set(solution.path.prefix(min(stepIndex, solution.path.count)))
    }

    var body: some View {
        Canvas { context, size in
            let side = min(size.width, size.height)
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let outerRadius = side * 0.47
            let ringRadius = side * 0.36
            let innerRadius = side * 0.19
            let nodeRadius = max(22, side * 0.058)

            drawSpaceBackground(context: &context, size: size)
            drawPlatform(context: &context, center: center, outerRadius: outerRadius, innerRadius: innerRadius)
            drawTicks(context: &context, center: center, radius: outerRadius, count: 120)
            drawSegmentArcs(context: &context, center: center, radius: ringRadius + nodeRadius * 0.82)
            drawHands(context: &context, center: center, radius: ringRadius, nodeRadius: nodeRadius)
            drawNodes(context: &context, center: center, radius: ringRadius, nodeRadius: nodeRadius)
        }
        .background(.black)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilitySummary)
    }

    private var accessibilitySummary: String {
        if let activeNode {
            return "Puzzle ring. Active node \(activeNode), value \(solution.values[activeNode])."
        }
        return "Puzzle ring. Solution complete."
    }

    private func drawSpaceBackground(context: inout GraphicsContext, size: CGSize) {
        let rect = CGRect(origin: .zero, size: size)
        context.fill(
            Path(rect),
            with: .linearGradient(
                Gradient(colors: [
                    Color(red: 0.02, green: 0.03, blue: 0.08),
                    Color(red: 0.0, green: 0.12, blue: 0.16),
                    Color(red: 0.01, green: 0.01, blue: 0.03)
                ]),
                startPoint: CGPoint(x: rect.minX, y: rect.minY),
                endPoint: CGPoint(x: rect.maxX, y: rect.maxY)
            )
        )

        for index in 0..<42 {
            let x = size.width * CGFloat((index * 37) % 101) / 101
            let y = size.height * CGFloat((index * 53) % 97) / 97
            let radius = CGFloat(index % 3 + 1) * 0.6
            context.fill(
                Path(ellipseIn: CGRect(x: x, y: y, width: radius, height: radius)),
                with: .color(.white.opacity(0.28))
            )
        }
    }

    private func drawPlatform(context: inout GraphicsContext, center: CGPoint, outerRadius: CGFloat, innerRadius: CGFloat) {
        context.fill(
            Path(ellipseIn: CGRect(center: center, radius: outerRadius)),
            with: .radialGradient(
                Gradient(colors: [
                    .cyan.opacity(0.18),
                    .blue.opacity(0.08),
                    .black.opacity(0.6)
                ]),
                center: center,
                startRadius: innerRadius,
                endRadius: outerRadius
            )
        )

        context.stroke(
            Path(ellipseIn: CGRect(center: center, radius: outerRadius)),
            with: .color(.cyan.opacity(0.55)),
            lineWidth: 2
        )
        context.stroke(
            Path(ellipseIn: CGRect(center: center, radius: innerRadius)),
            with: .color(.blue.opacity(0.65)),
            lineWidth: 3
        )
        context.stroke(
            Path(ellipseIn: CGRect(center: center, radius: innerRadius * 0.72)),
            with: .color(.cyan.opacity(0.35)),
            lineWidth: 2
        )
    }

    private func drawTicks(context: inout GraphicsContext, center: CGPoint, radius: CGFloat, count: Int) {
        for tick in 0..<count {
            let angle = Angle.degrees(Double(tick) / Double(count) * 360 - 90).radians
            let length: CGFloat = tick.isMultiple(of: 5) ? 12 : 6
            let color: Color = tick.isMultiple(of: 12) ? .yellow.opacity(0.72) : .cyan.opacity(0.45)
            var path = Path()
            path.move(to: point(center: center, radius: radius - length, angle: angle))
            path.addLine(to: point(center: center, radius: radius, angle: angle))
            context.stroke(path, with: .color(color), lineWidth: tick.isMultiple(of: 5) ? 1.5 : 0.8)
        }
    }

    private func drawSegmentArcs(context: inout GraphicsContext, center: CGPoint, radius: CGFloat) {
        for index in solution.values.indices {
            let start = nodeAngle(index) - .pi / CGFloat(solution.values.count) * 0.72
            let end = nodeAngle(index) + .pi / CGFloat(solution.values.count) * 0.72
            var arc = Path()
            arc.addArc(
                center: center,
                radius: radius,
                startAngle: .radians(start),
                endAngle: .radians(end),
                clockwise: false
            )
            context.stroke(
                arc,
                with: .color(NodeColor.palette[solution.values[index], default: .cyan].opacity(0.55)),
                lineWidth: 3
            )
        }
    }

    private func drawHands(context: inout GraphicsContext, center: CGPoint, radius: CGFloat, nodeRadius: CGFloat) {
        guard let activeNode else {
            context.fill(Path(ellipseIn: CGRect(center: center, radius: nodeRadius * 0.35)), with: .color(.yellow.opacity(0.8)))
            return
        }

        drawHand(context: &context, center: center, radius: radius - nodeRadius * 0.35, angle: nodeAngle(activeNode), color: .yellow)

        if let nextNode {
            drawHand(
                context: &context,
                center: center,
                radius: radius - nodeRadius * 0.8,
                angle: nodeAngle(nextNode),
                color: .orange.opacity(0.82)
            )
        }

        context.fill(Path(ellipseIn: CGRect(center: center, radius: nodeRadius * 0.34)), with: .color(.yellow.opacity(0.85)))
        context.stroke(Path(ellipseIn: CGRect(center: center, radius: nodeRadius * 0.6)), with: .color(.cyan.opacity(0.5)), lineWidth: 2)
    }

    private func drawHand(context: inout GraphicsContext, center: CGPoint, radius: CGFloat, angle: CGFloat, color: Color) {
        var path = Path()
        path.move(to: center)
        path.addLine(to: point(center: center, radius: radius, angle: angle))
        context.stroke(path, with: .color(color.opacity(0.9)), lineWidth: 5)

        let tip = point(center: center, radius: radius, angle: angle)
        context.fill(Path(ellipseIn: CGRect(center: tip, radius: 5)), with: .color(color))
    }

    private func drawNodes(context: inout GraphicsContext, center: CGPoint, radius: CGFloat, nodeRadius: CGFloat) {
        for index in solution.values.indices {
            let value = solution.values[index]
            let nodeCenter = point(center: center, radius: radius, angle: nodeAngle(index))
            let isActive = activeNode == index
            let isNext = nextNode == index
            let isCompleted = completedNodes.contains(index)
            let baseColor = NodeColor.palette[value, default: .cyan]
            let opacity = isCompleted ? 0.32 : 1.0

            if isActive || isNext {
                context.fill(
                    Path(ellipseIn: CGRect(center: nodeCenter, radius: nodeRadius * 1.42)),
                    with: .radialGradient(
                        Gradient(colors: [
                            baseColor.opacity(0.72),
                            baseColor.opacity(0.12),
                            .clear
                        ]),
                        center: nodeCenter,
                        startRadius: 0,
                        endRadius: nodeRadius * 1.42
                    )
                )
            }

            context.fill(
                Path(ellipseIn: CGRect(center: nodeCenter, radius: nodeRadius)),
                with: .radialGradient(
                    Gradient(colors: [
                        baseColor.opacity(0.65 * opacity),
                        Color.black.opacity(0.72)
                    ]),
                    center: nodeCenter,
                    startRadius: 0,
                    endRadius: nodeRadius
                )
            )

            context.stroke(
                Path(ellipseIn: CGRect(center: nodeCenter, radius: nodeRadius)),
                with: .color((isActive ? Color.white : baseColor).opacity(isActive ? 0.95 : 0.72 * opacity)),
                lineWidth: isActive ? 4 : 2
            )

            context.draw(
                Text("\(value)")
                    .font(.system(size: nodeRadius * 1.12, weight: .heavy, design: .rounded))
                    .foregroundStyle(baseColor.opacity(opacity)),
                at: nodeCenter,
                anchor: .center
            )
        }
    }

    private func nodeAngle(_ index: Int) -> CGFloat {
        (.pi * 2 * CGFloat(index) / CGFloat(solution.values.count)) - .pi / 2
    }

    private func point(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
    }
}

enum NodeColor {
    static let palette: [Int: Color] = [
        1: Color(red: 1.0, green: 0.25, blue: 0.22),
        2: Color(red: 1.0, green: 0.67, blue: 0.24),
        3: Color(red: 0.45, green: 0.95, blue: 0.34),
        4: Color(red: 0.28, green: 0.90, blue: 1.0),
        5: Color(red: 0.75, green: 0.38, blue: 1.0),
        6: Color(red: 1.0, green: 0.46, blue: 0.72)
    ]
}

private extension CGRect {
    init(center: CGPoint, radius: CGFloat) {
        self.init(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        )
    }
}

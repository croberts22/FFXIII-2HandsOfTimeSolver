import HandsOfTimeCore
import SwiftUI

struct PuzzleRingView: View {
    let solution: HandsOfTimeSolution
    let stepIndex: Int
    let reduceMotion: Bool
    var onRecommendedNodeTap: (() -> Void)?

    @State private var selectionAnimationStart = Date()

    private let selectionDuration: TimeInterval = 1.55
    private let handNodeClearance: CGFloat = 8
    private let handOuterStrokeWidth: CGFloat = 15
    private let handOpacity: CGFloat = 0.92
    private let completedNodeDimmedOpacity: CGFloat = 0.2
    private let selectableRingColor = Color(red: 0.46, green: 0.88, blue: 1.0)
    private let recommendedNodeColor = Color(red: 1.0, green: 0.78, blue: 0.18)
    private let innerRingColor = Color(red: 1.0, green: 0.76, blue: 0.30)

    private var activeNode: Int? {
        guard !solution.path.isEmpty, stepIndex < solution.path.count else {
            return nil
        }

        if stepIndex == 0 {
            return solution.path[0]
        }

        return solution.path[stepIndex - 1]
    }

    private var nextNode: Int? {
        guard stepIndex > 0, stepIndex - 1 < solution.steps.count else {
            return nil
        }
        return solution.steps[stepIndex - 1].nextIndex
    }

    private var isInitialSelection: Bool {
        stepIndex == 0
    }

    private var recommendedNode: Int? {
        guard stepIndex < solution.path.count else {
            return nil
        }

        if isInitialSelection {
            return activeNode
        }

        return nextNode
    }

    private var candidateNodes: Set<Int> {
        guard !isInitialSelection, let activeNode, nextNode != nil else {
            return []
        }

        let value = solution.values[activeNode]
        return [
            circularIndex(activeNode - value, count: solution.values.count),
            circularIndex(activeNode + value, count: solution.values.count)
        ]
    }

    private var completedNodes: Set<Int> {
        guard stepIndex > 0 else {
            return []
        }

        return Set(solution.path.prefix(stepIndex))
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let side = min(size.width, size.height)
                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let outerRadius = side * 0.47
                let ringRadius = side * 0.36
                let innerRadius = side * 0.19
                let nodeRadius = max(22, side * 0.058)
                let glowPhase = reduceMotion ? 0 : CGFloat(timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 3.6) / 3.6)
                let progress = reduceMotion ? 1 : selectionProgress(at: timeline.date)
                let ringVisibility = ringVisibility(for: progress)

                drawPlatform(context: &context, center: center, outerRadius: outerRadius, innerRadius: innerRadius, glowPhase: glowPhase)
                drawTicks(context: &context, center: center, radius: outerRadius, count: 120, glowPhase: glowPhase)
                drawSegmentArcs(
                    context: &context,
                    center: center,
                    radius: ringRadius + nodeRadius * 0.82,
                    ringVisibility: ringVisibility,
                    progress: progress
                )
                drawHands(context: &context, center: center, radius: ringRadius, nodeRadius: nodeRadius, progress: progress)
                drawNodes(
                    context: &context,
                    center: center,
                    radius: ringRadius,
                    nodeRadius: nodeRadius,
                    glowPhase: glowPhase,
                    selectionPulse: selectionPulse(for: progress),
                    progress: progress
                )
            }
        }
        .overlay {
            GeometryReader { geometry in
                if let recommendedNode, let onRecommendedNodeTap {
                    recommendedNodeTapTarget(
                        size: geometry.size,
                        nodeIndex: recommendedNode,
                        action: onRecommendedNodeTap
                    )
                }
            }
        }
        .background(.clear)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilitySummary)
        .accessibilityAction(named: "Next step") {
            if recommendedNode != nil {
                onRecommendedNodeTap?()
            }
        }
        .onAppear(perform: playSelectionAnimation)
        .onChange(of: stepIndex) {
            playSelectionAnimation()
        }
        .onChange(of: reduceMotion) {
            playSelectionAnimation()
        }
    }

    private var accessibilitySummary: String {
        if let activeNode {
            return "Puzzle ring. Active node \(activeNode), value \(solution.values[activeNode])."
        }
        return "Puzzle ring. Solution complete."
    }

    private func drawPlatform(
        context: inout GraphicsContext,
        center: CGPoint,
        outerRadius: CGFloat,
        innerRadius: CGFloat,
        glowPhase: CGFloat
    ) {
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

        drawOrbitGlow(
            context: &context,
            center: center,
            radius: outerRadius * 0.98,
            phase: glowPhase,
            color: .cyan,
            lineWidth: 5,
            sweep: .pi * 0.18,
            opacity: 0.72
        )
        drawOrbitGlow(
            context: &context,
            center: center,
            radius: outerRadius * 0.88,
            phase: glowPhase + 0.34,
            color: .white,
            lineWidth: 3,
            sweep: .pi * 0.14,
            opacity: 0.44
        )
        drawOrbitGlow(
            context: &context,
            center: center,
            radius: innerRadius,
            phase: 1 - glowPhase,
            color: .blue,
            lineWidth: 5,
            sweep: .pi * 0.34,
            opacity: 0.7
        )
    }

    private func drawTicks(context: inout GraphicsContext, center: CGPoint, radius: CGFloat, count: Int, glowPhase: CGFloat) {
        for tick in 0 ..< count {
            let angle = Angle.degrees(Double(tick) / Double(count) * 360 - 90).radians
            let length: CGFloat = tick.isMultiple(of: 5) ? 12 : 6
            let tickPhase = CGFloat(tick) / CGFloat(count)
            let chase = max(0, 1 - circularDistance(tickPhase, glowPhase) / 0.06)
            let baseOpacity = tick.isMultiple(of: 12) ? 0.72 : 0.42
            let color: Color = tick.isMultiple(of: 12) ? .yellow.opacity(baseOpacity + Double(chase) * 0.2) : .cyan.opacity(baseOpacity + Double(chase) * 0.38)
            var path = Path()
            path.move(to: point(center: center, radius: radius - length, angle: angle))
            path.addLine(to: point(center: center, radius: radius, angle: angle))
            context.stroke(path, with: .color(color), lineWidth: (tick.isMultiple(of: 5) ? 1.5 : 0.8) + chase * 1.3)
        }
    }

    private func drawSegmentArcs(
        context: inout GraphicsContext,
        center: CGPoint,
        radius: CGFloat,
        ringVisibility: CGFloat,
        progress: CGFloat
    ) {
        for index in solution.values.indices {
            let start = nodeAngle(index) - .pi / CGFloat(solution.values.count) * 0.72
            let end = nodeAngle(index) + .pi / CGFloat(solution.values.count) * 0.72
            let baseColor = NodeColor.palette[solution.values[index], default: .cyan]
            let arcOpacity = completedNodeOpacity(for: index, progress: progress)
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
                with: .color(baseColor.opacity(Double(0.24 + ringVisibility * 0.36) * arcOpacity)),
                lineWidth: 3
            )
        }
    }

    private func drawHands(context: inout GraphicsContext, center: CGPoint, radius: CGFloat, nodeRadius: CGFloat, progress: CGFloat) {
        guard let activeNode else {
            context.fill(Path(ellipseIn: CGRect(center: center, radius: nodeRadius * 0.35)), with: .color(.yellow.opacity(0.8)))
            return
        }

        let handColor = Color.yellow

        if isInitialSelection {
            let handRadius = handRadius(for: radius, nodeRadius: nodeRadius)
            drawHand(
                context: &context,
                center: center,
                radius: handRadius,
                angle: -.pi / 2,
                color: handColor,
                opacity: handOpacity,
                nodeRadius: nodeRadius
            )
            drawHand(
                context: &context,
                center: center,
                radius: handRadius,
                angle: -.pi / 2,
                color: handColor,
                opacity: handOpacity,
                nodeRadius: nodeRadius
            )
            context.fill(Path(ellipseIn: CGRect(center: center, radius: nodeRadius * 0.34)), with: .color(.yellow.opacity(0.86)))
            context.stroke(Path(ellipseIn: CGRect(center: center, radius: nodeRadius * 0.6)), with: .color(.cyan.opacity(0.58)), lineWidth: 2)
            return
        }

        let value = solution.values[activeNode]
        let activeAngle = nodeAngle(activeNode)
        let startAngles = handStartAngles()
        let arrival = easeOut(clamp(progress / 0.46))
        let split = handFanOutProgress(for: progress)
        let leftArrivalAngle = interpolateAngle(from: startAngles.left, to: activeAngle, progress: arrival)
        let rightArrivalAngle = interpolateAngle(from: startAngles.right, to: activeAngle, progress: arrival)
        let leftAngle = activeAngle - (.pi * 2 * CGFloat(value) / CGFloat(solution.values.count)) * split
        let rightAngle = activeAngle + (.pi * 2 * CGFloat(value) / CGFloat(solution.values.count)) * split
        let handRadius = handRadius(for: radius, nodeRadius: nodeRadius)

        if split == 0 {
            drawHand(
                context: &context,
                center: center,
                radius: handRadius,
                angle: leftArrivalAngle,
                color: handColor,
                opacity: handOpacity,
                nodeRadius: nodeRadius
            )
            drawHand(
                context: &context,
                center: center,
                radius: handRadius,
                angle: rightArrivalAngle,
                color: handColor,
                opacity: handOpacity,
                nodeRadius: nodeRadius
            )
        } else {
            drawHand(
                context: &context,
                center: center,
                radius: handRadius,
                angle: leftAngle,
                color: handColor,
                opacity: handOpacity,
                nodeRadius: nodeRadius
            )
            drawHand(
                context: &context,
                center: center,
                radius: handRadius,
                angle: rightAngle,
                color: handColor,
                opacity: handOpacity,
                nodeRadius: nodeRadius
            )
        }

        context.fill(Path(ellipseIn: CGRect(center: center, radius: nodeRadius * 0.34)), with: .color(.yellow.opacity(0.86)))
        context.stroke(Path(ellipseIn: CGRect(center: center, radius: nodeRadius * 0.6)), with: .color(.cyan.opacity(0.58)), lineWidth: 2)
        drawOrbitGlow(
            context: &context,
            center: center,
            radius: nodeRadius * 0.72,
            phase: progress,
            color: .blue,
            lineWidth: 3,
            sweep: .pi * 0.9,
            opacity: 0.7
        )
    }

    private func drawHand(
        context: inout GraphicsContext,
        center: CGPoint,
        radius: CGFloat,
        angle: CGFloat,
        color: Color,
        opacity: CGFloat,
        nodeRadius: CGFloat
    ) {
        let arrowLength = max(14, nodeRadius * 0.58)
        let arrowHalfWidth = max(handOuterStrokeWidth * 0.58, nodeRadius * 0.34)
        let tip = point(center: center, radius: radius, angle: angle)
        let arrowBase = point(center: tip, radius: arrowLength, angle: angle + .pi)

        var path = Path()
        path.move(to: center)
        path.addLine(to: arrowBase)
        context.stroke(path, with: .color(color.opacity(Double(opacity * 0.2))), style: StrokeStyle(lineWidth: handOuterStrokeWidth, lineCap: .round))
        context.stroke(path, with: .color(color.opacity(Double(opacity * 0.82))), style: StrokeStyle(lineWidth: 8, lineCap: .round))
        context.stroke(path, with: .color(.white.opacity(Double(opacity * 0.42))), style: StrokeStyle(lineWidth: 3, lineCap: .round))

        let sideA = point(center: arrowBase, radius: arrowHalfWidth, angle: angle + .pi / 2)
        let sideB = point(center: arrowBase, radius: arrowHalfWidth, angle: angle - .pi / 2)
        var head = Path()
        head.move(to: tip)
        head.addLine(to: sideA)
        head.addLine(to: sideB)
        head.closeSubpath()
        context.fill(head, with: .color(color.opacity(Double(opacity))))
        context.stroke(head, with: .color(.white.opacity(Double(opacity * 0.5))), lineWidth: 1.5)
    }

    private func handRadius(for radius: CGFloat, nodeRadius: CGFloat) -> CGFloat {
        max(0, radius - nodeRadius - handNodeClearance)
    }

    private func drawNodes(
        context: inout GraphicsContext,
        center: CGPoint,
        radius: CGFloat,
        nodeRadius: CGFloat,
        glowPhase: CGFloat,
        selectionPulse: CGFloat,
        progress: CGFloat
    ) {
        let split = selectionSplit(for: progress)

        for index in solution.values.indices {
            let value = solution.values[index]
            let nodeCenter = point(center: center, radius: radius, angle: nodeAngle(index))
            let isActive = activeNode == index
            let isRecommended = isInitialSelection ? isActive : nextNode == index
            let isCandidate = candidateNodes.contains(index)
            let nodeOpacity = completedNodeOpacity(for: index, progress: progress)
            let baseColor = NodeColor.palette[value, default: .cyan]
            var nodeContext = context
            if nodeOpacity < 0.999 {
                nodeContext.opacity = nodeOpacity
            }
            let candidateHighlight = candidateRingHighlight(for: index, progress: progress)
            let passThroughHighlight = passThroughRingHighlight(for: index, split: split)
            let initialHighlight: CGFloat = isInitialSelection && isActive ? 1 : 0
            let selectionHighlight = max(initialHighlight, candidateHighlight, passThroughHighlight)
            let activePulse = isActive ? selectionPulse * 0.42 : 0
            let glowIntensity = max(selectionHighlight, activePulse)
            let pulseOpacity = Double(glowIntensity)
            let selectionColor = isRecommended ? recommendedNodeColor : selectableRingColor

            if glowIntensity > 0.02 {
                nodeContext.fill(
                    Path(ellipseIn: CGRect(center: nodeCenter, radius: nodeRadius * (1.24 + glowIntensity * 0.22))),
                    with: .radialGradient(
                        Gradient(colors: [
                            selectionColor.opacity(0.26 + pulseOpacity * 0.42),
                            selectionColor.opacity(0.10 + pulseOpacity * 0.12),
                            .clear
                        ]),
                        center: nodeCenter,
                        startRadius: 0,
                        endRadius: nodeRadius * 1.42
                    )
                )
            }

            nodeContext.fill(
                Path(ellipseIn: CGRect(center: nodeCenter, radius: nodeRadius)),
                with: .radialGradient(
                    Gradient(colors: [
                        baseColor.opacity(0.48),
                        Color.black.opacity(0.72)
                    ]),
                    center: nodeCenter,
                    startRadius: 0,
                    endRadius: nodeRadius
                )
            )

            nodeContext.stroke(
                Path(ellipseIn: CGRect(center: nodeCenter, radius: nodeRadius)),
                with: .color(baseColor.opacity(isActive ? 0.82 : 0.56)),
                lineWidth: isActive ? 3 : 2
            )

            nodeContext.stroke(
                Path(ellipseIn: CGRect(center: nodeCenter, radius: nodeRadius * 0.72)),
                with: .color(innerRingColor.opacity(0.34)),
                lineWidth: 1.1
            )

            drawOrbitGlow(
                context: &nodeContext,
                center: nodeCenter,
                radius: nodeRadius * 0.72,
                phase: glowPhase + CGFloat(index) * 0.071,
                color: innerRingColor,
                lineWidth: 1.4,
                sweep: .pi * 0.56,
                opacity: 0.26
            )

            if selectionHighlight > 0.02 {
                nodeContext.stroke(
                    Path(ellipseIn: CGRect(center: nodeCenter, radius: nodeRadius * 1.08)),
                    with: .color(selectionColor.opacity(Double(0.42 + selectionHighlight * 0.48))),
                    lineWidth: 2 + selectionHighlight * 2
                )

                drawOrbitGlow(
                    context: &nodeContext,
                    center: nodeCenter,
                    radius: nodeRadius * 1.08,
                    phase: glowPhase + CGFloat(index) * 0.071,
                    color: selectionColor,
                    lineWidth: isCandidate ? 4 : 3.4,
                    sweep: .pi * 0.72,
                    opacity: 0.36 + selectionHighlight * 0.48
                )
            }

            nodeContext.draw(
                Text("\(value)")
                    .font(.system(size: nodeRadius * 1.12, weight: .heavy, design: .rounded))
                    .foregroundStyle(baseColor),
                at: nodeCenter,
                anchor: .center
            )
        }
    }

    private func nodeAngle(_ index: Int) -> CGFloat {
        (.pi * 2 * CGFloat(index) / CGFloat(solution.values.count)) - .pi / 2
    }

    private func recommendedNodeTapTarget(size: CGSize, nodeIndex: Int, action: @escaping () -> Void) -> some View {
        let side = min(size.width, size.height)
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let ringRadius = side * 0.36
        let nodeRadius = max(22, side * 0.058)
        let nodeCenter = point(center: center, radius: ringRadius, angle: nodeAngle(nodeIndex))
        let tapDiameter = nodeRadius * 2.2

        return Button(action: action) {
            Circle()
                .fill(.clear)
                .contentShape(Circle())
                .frame(width: tapDiameter, height: tapDiameter)
        }
        .buttonStyle(.plain)
        .position(nodeCenter)
        .accessibilityHidden(true)
    }

    private func drawOrbitGlow(
        context: inout GraphicsContext,
        center: CGPoint,
        radius: CGFloat,
        phase: CGFloat,
        color: Color,
        lineWidth: CGFloat,
        sweep: CGFloat,
        opacity: CGFloat
    ) {
        let normalizedPhase = phase - floor(phase)
        let start = normalizedPhase * .pi * 2 - .pi / 2
        let trailCount = 3

        for trail in 0 ..< trailCount {
            let trailOffset = CGFloat(trail) * sweep * 0.72
            let trailOpacity = opacity * (1 - CGFloat(trail) * 0.28)
            var arc = Path()
            arc.addArc(
                center: center,
                radius: radius,
                startAngle: .radians(start - trailOffset),
                endAngle: .radians(start + sweep - trailOffset),
                clockwise: false
            )
            context.stroke(
                arc,
                with: .color(color.opacity(Double(max(0, trailOpacity)))),
                style: StrokeStyle(lineWidth: max(1, lineWidth - CGFloat(trail)), lineCap: .round)
            )
        }
    }

    private func point(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
    }

    private func playSelectionAnimation() {
        guard !reduceMotion, !isInitialSelection, activeNode != nil else {
            selectionAnimationStart = Date(timeIntervalSinceNow: -selectionDuration)
            return
        }

        selectionAnimationStart = Date()
    }

    private func handStartAngles() -> (left: CGFloat, right: CGFloat) {
        guard stepIndex > 1 else {
            return (-.pi / 2, -.pi / 2)
        }

        let sourceNode = solution.path[stepIndex - 2]
        let sourceValue = solution.values[sourceNode]
        let sourceAngle = nodeAngle(sourceNode)
        let offset = .pi * 2 * CGFloat(sourceValue) / CGFloat(solution.values.count)
        return (sourceAngle - offset, sourceAngle + offset)
    }

    private func handFanOutProgress(for progress: CGFloat) -> CGFloat {
        guard !isInitialSelection, nextNode != nil else {
            return 0
        }

        return easeInOut(clamp((progress - 0.58) / 0.42))
    }

    private func completedNodeOpacity(for index: Int, progress: CGFloat) -> CGFloat {
        guard completedNodes.contains(index) else {
            return 1
        }

        if stepIndex > 0, activeNode == index, nextNode != nil {
            let fanOut = handFanOutProgress(for: progress)
            return 1 - (1 - completedNodeDimmedOpacity) * fanOut
        }

        return completedNodeDimmedOpacity
    }

    private func ringVisibility(for progress: CGFloat) -> CGFloat {
        let beat = sin(clamp((progress - 0.22) / 0.5) * .pi)
        return 1 - beat * 0.88
    }

    private func selectionSplit(for progress: CGFloat) -> CGFloat {
        guard !isInitialSelection, activeNode != nil, nextNode != nil else {
            return 0
        }

        return easeInOut(clamp((progress - 0.58) / 0.26))
    }

    private func candidateRingHighlight(for index: Int, progress: CGFloat) -> CGFloat {
        guard !isInitialSelection, candidateNodes.contains(index), nextNode != nil else {
            return 0
        }

        return easeInOut(clamp((progress - 0.84) / 0.16))
    }

    private func passThroughRingHighlight(for index: Int, split: CGFloat) -> CGFloat {
        guard let activeNode, !isInitialSelection, nextNode != nil else {
            return 0
        }

        let value = solution.values[activeNode]
        guard value > 1 else {
            return 0
        }

        let count = solution.values.count
        let pulseWidth = max(0.06, min(0.18, 0.42 / CGFloat(value)))
        var strongestPulse: CGFloat = 0

        for distance in 1 ..< value {
            let leftNode = circularIndex(activeNode - distance, count: count)
            let rightNode = circularIndex(activeNode + distance, count: count)
            guard index == leftNode || index == rightNode else {
                continue
            }

            let passPosition = CGFloat(distance) / CGFloat(value)
            let pulse = max(0, 1 - abs(split - passPosition) / pulseWidth)
            strongestPulse = max(strongestPulse, pulse)
        }

        return easeInOut(strongestPulse)
    }

    private func selectionPulse(for progress: CGFloat) -> CGFloat {
        sin(clamp((progress - 0.24) / 0.62) * .pi)
    }

    private func selectionProgress(at date: Date) -> CGFloat {
        guard activeNode != nil else {
            return 1
        }

        return clamp(CGFloat(date.timeIntervalSince(selectionAnimationStart) / selectionDuration))
    }

    private func interpolateAngle(from start: CGFloat, to end: CGFloat, progress: CGFloat) -> CGFloat {
        let delta = atan2(sin(end - start), cos(end - start))
        return start + delta * progress
    }

    private func easeOut(_ value: CGFloat) -> CGFloat {
        1 - pow(1 - value, 3)
    }

    private func easeInOut(_ value: CGFloat) -> CGFloat {
        value * value * (3 - 2 * value)
    }

    private func clamp(_ value: CGFloat) -> CGFloat {
        min(1, max(0, value))
    }

    private func circularDistance(_ first: CGFloat, _ second: CGFloat) -> CGFloat {
        let distance = abs(first - second).truncatingRemainder(dividingBy: 1)
        return min(distance, 1 - distance)
    }
}

struct PuzzleInputRingView: View {
    let values: [Int]
    let reduceMotion: Bool

    private var accessibilitySummary: String {
        if values.isEmpty {
            return "Empty clock."
        }

        return "Clock values \(values.map(String.init).joined(separator: ", "))."
    }

    var body: some View {
        Color.clear
            .aspectRatio(1, contentMode: .fit)
            .overlay {
                GeometryReader { geometry in
                    let size = geometry.size
                    let side = min(size.width, size.height)
                    let center = CGPoint(x: size.width / 2, y: size.height / 2)
                    let ringRadius = side * 0.36
                    let nodeDiameter = max(34, min(52, side * 0.13))

                    ZStack {
                        PuzzleInputClockFace(reduceMotion: reduceMotion)

                        ForEach(Array(values.enumerated()), id: \.offset) { item in
                            PuzzleInputNode(value: item.element, diameter: nodeDiameter)
                                .position(point(center: center, radius: ringRadius, angle: nodeAngle(item.offset, count: values.count)))
                                .transition(.scale(scale: 0.35).combined(with: .opacity))
                                .zIndex(Double(item.offset))
                        }
                    }
                    .frame(width: size.width, height: size.height)
                }
            }
            .background(.clear)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .accessibilityElement(children: .ignore)
            .accessibilityLabel(accessibilitySummary)
            .animation(reduceMotion ? nil : Animation.snappy(duration: 0.35), value: values)
    }

    private func nodeAngle(_ index: Int, count: Int) -> CGFloat {
        guard count > 0 else {
            return -.pi / 2
        }

        return (.pi * 2 * CGFloat(index) / CGFloat(count)) - .pi / 2
    }

    private func point(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
    }
}

private struct PuzzleInputClockFace: View {
    let reduceMotion: Bool

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let side = min(size.width, size.height)
                guard side > 0 else {
                    return
                }

                let center = CGPoint(x: size.width / 2, y: size.height / 2)
                let outerRadius = side * 0.47
                let ringRadius = side * 0.36
                let innerRadius = side * 0.19
                let glowPhase = reduceMotion ? 0 : CGFloat(timeline.date.timeIntervalSinceReferenceDate.truncatingRemainder(dividingBy: 3.6) / 3.6)

                drawPlatform(context: &context, center: center, outerRadius: outerRadius, innerRadius: innerRadius, glowPhase: glowPhase)
                drawTicks(context: &context, center: center, radius: outerRadius, count: 120, glowPhase: glowPhase)

                context.stroke(
                    Path(ellipseIn: CGRect(center: center, radius: ringRadius)),
                    with: .color(.cyan.opacity(0.22)),
                    lineWidth: 2
                )

                drawOrbitGlow(
                    context: &context,
                    center: center,
                    radius: ringRadius,
                    phase: 1 - glowPhase,
                    color: .cyan,
                    lineWidth: 3,
                    sweep: .pi * 0.22,
                    opacity: 0.34
                )
            }
        }
    }

    private func drawPlatform(
        context: inout GraphicsContext,
        center: CGPoint,
        outerRadius: CGFloat,
        innerRadius: CGFloat,
        glowPhase: CGFloat
    ) {
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

        drawOrbitGlow(
            context: &context,
            center: center,
            radius: outerRadius * 0.98,
            phase: glowPhase,
            color: .cyan,
            lineWidth: 5,
            sweep: .pi * 0.18,
            opacity: 0.72
        )
        drawOrbitGlow(
            context: &context,
            center: center,
            radius: outerRadius * 0.88,
            phase: glowPhase + 0.34,
            color: .white,
            lineWidth: 3,
            sweep: .pi * 0.14,
            opacity: 0.44
        )
        drawOrbitGlow(
            context: &context,
            center: center,
            radius: innerRadius,
            phase: 1 - glowPhase,
            color: .blue,
            lineWidth: 5,
            sweep: .pi * 0.34,
            opacity: 0.7
        )
    }

    private func drawTicks(context: inout GraphicsContext, center: CGPoint, radius: CGFloat, count: Int, glowPhase: CGFloat) {
        for tick in 0 ..< count {
            let angle = Angle.degrees(Double(tick) / Double(count) * 360 - 90).radians
            let length: CGFloat = tick.isMultiple(of: 5) ? 12 : 6
            let tickPhase = CGFloat(tick) / CGFloat(count)
            let chase = max(0, 1 - circularDistance(tickPhase, glowPhase) / 0.06)
            let baseOpacity = tick.isMultiple(of: 12) ? 0.72 : 0.42
            let color: Color = tick.isMultiple(of: 12) ? .yellow.opacity(baseOpacity + Double(chase) * 0.2) : .cyan.opacity(baseOpacity + Double(chase) * 0.38)
            var path = Path()
            path.move(to: point(center: center, radius: radius - length, angle: angle))
            path.addLine(to: point(center: center, radius: radius, angle: angle))
            context.stroke(path, with: .color(color), lineWidth: (tick.isMultiple(of: 5) ? 1.5 : 0.8) + chase * 1.3)
        }
    }

    private func drawOrbitGlow(
        context: inout GraphicsContext,
        center: CGPoint,
        radius: CGFloat,
        phase: CGFloat,
        color: Color,
        lineWidth: CGFloat,
        sweep: CGFloat,
        opacity: CGFloat
    ) {
        let normalizedPhase = phase - floor(phase)
        let start = normalizedPhase * .pi * 2 - .pi / 2
        let trailCount = 3

        for trail in 0 ..< trailCount {
            let trailOffset = CGFloat(trail) * sweep * 0.72
            let trailOpacity = opacity * (1 - CGFloat(trail) * 0.28)
            var arc = Path()
            arc.addArc(
                center: center,
                radius: radius,
                startAngle: .radians(start - trailOffset),
                endAngle: .radians(start + sweep - trailOffset),
                clockwise: false
            )
            context.stroke(
                arc,
                with: .color(color.opacity(Double(max(0, trailOpacity)))),
                style: StrokeStyle(lineWidth: max(1, lineWidth - CGFloat(trail)), lineCap: .round)
            )
        }
    }

    private func point(center: CGPoint, radius: CGFloat, angle: CGFloat) -> CGPoint {
        CGPoint(
            x: center.x + cos(angle) * radius,
            y: center.y + sin(angle) * radius
        )
    }

    private func circularDistance(_ first: CGFloat, _ second: CGFloat) -> CGFloat {
        let distance = abs(first - second).truncatingRemainder(dividingBy: 1)
        return min(distance, 1 - distance)
    }
}

private struct PuzzleInputNode: View {
    let value: Int
    let diameter: CGFloat

    private let innerRingColor = Color(red: 1.0, green: 0.76, blue: 0.30)

    var body: some View {
        let baseColor = NodeColor.palette[value, default: .cyan]

        ZStack {
            Circle()
                .fill(
                    RadialGradient(
                        gradient: Gradient(colors: [
                            baseColor.opacity(0.48),
                            Color.black.opacity(0.72)
                        ]),
                        center: .center,
                        startRadius: 0,
                        endRadius: diameter / 2
                    )
                )

            Circle()
                .stroke(baseColor.opacity(0.62), lineWidth: 2)

            Circle()
                .stroke(innerRingColor.opacity(0.34), lineWidth: 1.1)
                .scaleEffect(0.72)

            Text("\(value)")
                .font(.system(size: max(19, diameter * 0.56), weight: .heavy, design: .rounded))
                .foregroundStyle(baseColor)
        }
        .frame(width: diameter, height: diameter)
        .shadow(color: baseColor.opacity(0.35), radius: 8)
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

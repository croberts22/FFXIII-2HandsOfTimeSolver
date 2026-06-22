import HandsOfTimeCore
import SwiftUI

struct SolutionView: View {
    let solution: HandsOfTimeSolution

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var stepIndex = 0

    private var isComplete: Bool {
        stepIndex >= solution.path.count
    }

    private var instructionText: Text {
        if isComplete {
            return Text("Solved! Set up another puzzle when ready.")
        } else if stepIndex == 0 {
            let firstValue = solution.values[solution.path[0]]
            return Text("Select the highlighted ") + coloredNumber(firstValue) + Text(".")
        } else {
            let step = solution.steps[stepIndex - 1]
            let direction = step.direction == .right ? "forwards" : "backwards"
            let nextValue = step.nextValue ?? step.currentValue
            return Text("From ")
                + coloredNumber(step.currentValue)
                + Text(", move \(direction) to ")
                + coloredNumber(nextValue)
                + Text(".")
        }
    }

    private func coloredNumber(_ value: Int) -> Text {
        Text("\(value)")
            .foregroundStyle(NodeColor.palette[value, default: .cyan])
    }

    var body: some View {
        ZStack {
            AppSpaceBackground()
                .ignoresSafeArea()

            VStack(spacing: 18) {
                PuzzleRingView(solution: solution, stepIndex: stepIndex, reduceMotion: reduceMotion)
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.horizontal)

                VStack(alignment: .leading, spacing: 8) {
                    instructionText
                        .font(.headline)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding()
                .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
                .padding(.horizontal)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        }
        .navigationTitle("Solution")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button("Back") {
                    withStepAnimation {
                        stepIndex = max(0, stepIndex - 1)
                    }
                }
                .disabled(stepIndex == 0)

                Spacer()

                Button("Next") {
                    withStepAnimation {
                        stepIndex = min(solution.path.count, stepIndex + 1)
                    }
                }
                .disabled(isComplete)
            }
        }
        .toolbarBackground(.visible, for: .bottomBar)
    }

    private func withStepAnimation(_ update: () -> Void) {
        if reduceMotion {
            update()
        } else {
            withAnimation(.snappy(duration: 0.35)) {
                update()
            }
        }
    }
}

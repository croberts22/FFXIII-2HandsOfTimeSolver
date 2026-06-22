import HandsOfTimeCore
import SwiftUI

struct SolutionView: View {
    let solution: HandsOfTimeSolution

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var stepIndex = 0

    private var isComplete: Bool {
        stepIndex >= solution.path.count
    }

    private var instruction: String {
        if isComplete {
            return "Solved! Set up another puzzle when ready."
        }

        if stepIndex == 0 {
            let firstValue = solution.values[solution.path[0]]
            return "Select the highlighted \(firstValue)."
        }

        let step = solution.steps[stepIndex - 1]
        let direction = step.direction == .right ? "forwards" : "backwards"
        return "From \(step.currentValue), move \(direction) to \(step.nextValue ?? step.currentValue)."
    }

    var body: some View {
        VStack(spacing: 18) {
            PuzzleRingView(solution: solution, stepIndex: stepIndex, reduceMotion: reduceMotion)
                .aspectRatio(1, contentMode: .fit)
                .padding(.horizontal)

            VStack(alignment: .leading, spacing: 8) {
                Text(instruction)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)

            }
            .padding()
            .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
            .padding(.horizontal)

            HStack(spacing: 12) {
                Button {
                    withStepAnimation {
                        stepIndex = max(0, stepIndex - 1)
                    }
                } label: {
                    Label("Back", systemImage: "chevron.left")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.bordered)
                .disabled(stepIndex == 0)

                Button {
                    withStepAnimation {
                        stepIndex = min(solution.path.count, stepIndex + 1)
                    }
                } label: {
                    Label(isComplete ? "Solved" : "Next", systemImage: isComplete ? "checkmark" : "chevron.right")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .disabled(isComplete)
            }
            .padding(.horizontal)
            .padding(.bottom)
        }
        .navigationTitle("Solution")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .background {
            AppSpaceBackground()
                .ignoresSafeArea()
        }
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

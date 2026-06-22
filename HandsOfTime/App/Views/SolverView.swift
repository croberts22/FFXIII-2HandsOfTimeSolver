import HandsOfTimeCore
import SwiftData
import SwiftUI

struct SolverView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var viewModel = PuzzleInputViewModel()
    @State private var displayedSolution: DisplayedSolution?

    private let keypadColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Enter the numbers clockwise, starting from the top.")
                        .font(.headline)
                        .foregroundStyle(.white)

                    PuzzleInputRingView(values: viewModel.values, reduceMotion: reduceMotion)
                        .frame(maxWidth: 420)
                        .frame(maxWidth: .infinity)
                }

                LazyVGrid(columns: keypadColumns, spacing: 12) {
                    ForEach(1...6, id: \.self) { value in
                        Button {
                            withInputAnimation {
                                viewModel.append(value)
                            }
                        } label: {
                            Text("\(value)")
                                .font(.system(size: 30, weight: .bold, design: .rounded))
                                .frame(maxWidth: .infinity, minHeight: 68)
                        }
                        .buttonStyle(NumberButtonStyle(value: value))
                        .disabled(viewModel.values.count >= HandsOfTimePuzzle.maximumCount)
                    }
                }

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.callout)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .scrollContentBackground(.hidden)
        .toolbarBackground(.hidden, for: .navigationBar)
        .background {
            AppSpaceBackground()
                .ignoresSafeArea()
        }
        .navigationTitle("Hands of Time")
        .safeAreaInset(edge: .bottom, spacing: 0) {
            SolverActionBar(
                canUndo: !viewModel.values.isEmpty,
                canSolve: viewModel.canSolve,
                undo: {
                    withInputAnimation {
                        viewModel.undo()
                    }
                },
                solve: solvePuzzle
            )
        }
        .sheet(item: $displayedSolution) { displayedSolution in
            NavigationStack {
                SolutionView(solution: displayedSolution.solution)
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") {
                                self.displayedSolution = nil
                            }
                        }
                    }
            }
        }
    }

    private func solvePuzzle() {
        guard let solution = viewModel.solve() else {
            return
        }

        modelContext.insert(PuzzleHistoryEntry(solution: solution))
        displayedSolution = DisplayedSolution(solution: solution)
    }

    private func withInputAnimation(_ update: () -> Void) {
        if reduceMotion {
            update()
        } else {
            withAnimation(.snappy(duration: 0.35)) {
                update()
            }
        }
    }
}

private struct SolverActionBar: View {
    let canUndo: Bool
    let canSolve: Bool
    let undo: () -> Void
    let solve: () -> Void

    var body: some View {
        HStack {
            Button(action: undo) {
                Image(systemName: "arrow.counterclockwise")
            }
            .disabled(!canUndo)
            .accessibilityLabel("Undo")

            Spacer()

            Button(action: solve) {
                Text("Solve")
                    .font(.headline)
            }
            .buttonStyle(.borderedProminent)
            .tint(.cyan)
            .disabled(!canSolve)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial)
        .overlay(alignment: .top) {
            Divider()
        }
    }
}

private struct DisplayedSolution: Identifiable {
    let id = UUID()
    let solution: HandsOfTimeSolution
}

private struct NumberButtonStyle: ButtonStyle {
    let value: Int

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .foregroundStyle(.white)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(NodeColor.palette[value, default: .cyan].opacity(configuration.isPressed ? 0.72 : 1.0))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.white.opacity(configuration.isPressed ? 0.7 : 0.35), lineWidth: 1)
            )
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}

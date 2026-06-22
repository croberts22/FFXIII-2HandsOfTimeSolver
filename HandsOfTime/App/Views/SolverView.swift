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
                    Text("Clock Values")
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

                HStack(spacing: 12) {
                    Button {
                        withInputAnimation {
                            viewModel.deleteLast()
                        }
                    } label: {
                        Label("Delete", systemImage: "delete.left")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(!viewModel.canDelete)

                    Button {
                        withInputAnimation {
                            viewModel.reset()
                        }
                    } label: {
                        Label("Reset", systemImage: "arrow.counterclockwise")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(viewModel.values.isEmpty)
                }

                Button {
                    solvePuzzle()
                } label: {
                    Label("Solve Clock", systemImage: "play.fill")
                        .font(.headline)
                        .frame(maxWidth: .infinity, minHeight: 48)
                }
                .buttonStyle(.borderedProminent)
                .disabled(!viewModel.canSolve)

                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.callout)
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .padding()
        }
        .background(.clear)
        .scrollContentBackground(.hidden)
        .navigationTitle("Hands of Time")
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

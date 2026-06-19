import HandsOfTimeCore
import SwiftData
import SwiftUI

struct SolverView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var viewModel = PuzzleInputViewModel()
    @State private var displayedSolution: DisplayedSolution?

    private let keypadColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                VStack(alignment: .leading, spacing: 12) {
                    Text("Clock Values")
                        .font(.headline)

                    SequenceDisplay(values: viewModel.values)
                        .frame(maxWidth: .infinity, minHeight: 74)
                }

                LazyVGrid(columns: keypadColumns, spacing: 12) {
                    ForEach(1...6, id: \.self) { value in
                        Button {
                            viewModel.append(value)
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
                        viewModel.deleteLast()
                    } label: {
                        Label("Delete", systemImage: "delete.left")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                    .disabled(!viewModel.canDelete)

                    Button {
                        viewModel.reset()
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
}

private struct DisplayedSolution: Identifiable {
    let id = UUID()
    let solution: HandsOfTimeSolution
}

private struct SequenceDisplay: View {
    let values: [Int]

    var body: some View {
        Group {
            if values.isEmpty {
                Text("Enter values 1-6")
                    .font(.title2.weight(.semibold))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(values.enumerated()), id: \.offset) { _, value in
                            Text("\(value)")
                                .font(.title2.weight(.bold))
                                .foregroundStyle(.white)
                                .frame(width: 44, height: 44)
                                .background(NodeColor.palette[value, default: .cyan].gradient, in: Circle())
                                .overlay(Circle().stroke(.white.opacity(0.45), lineWidth: 1))
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .padding(16)
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 8))
        .accessibilityLabel(values.isEmpty ? "No values entered" : "Entered values \(values.map(String.init).joined(separator: ", "))")
    }
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

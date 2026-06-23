import HandsOfTimeCore
import SwiftData
import SwiftUI

struct SolverView: View {
    private static let keypadMaxWidth: CGFloat = 400
    private static let puzzleRingMaxWidthCompact: CGFloat = 420
    private static let puzzleRingMaxWidthRegular: CGFloat = 560

    @Environment(\.modelContext) private var modelContext
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var viewModel = PuzzleInputViewModel()
    @State private var displayedSolution: DisplayedSolution?
    @State private var toast: Toast?

    private let keypadColumns = Array(repeating: GridItem(.flexible(), spacing: 12), count: 3)
    private let noSolutionToastMessage = "No solution exists for this clock."

    var body: some View {
        VStack(spacing: 20) {
            Text("Enter the numbers clockwise, starting from the top.")
                .font(.headline)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)

            PuzzleInputRingView(values: viewModel.values, reduceMotion: reduceMotion)
                .frame(maxWidth: puzzleRingMaxWidth)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)

            LazyVGrid(columns: keypadColumns, spacing: 12) {
                ForEach(1 ... 6, id: \.self) { value in
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
            .frame(maxWidth: Self.keypadMaxWidth)
            .frame(maxWidth: .infinity)
        }
        .padding(.horizontal, horizontalSizeClass == .regular ? 64 : 16)
        .padding(.vertical, 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay(alignment: .bottom) {
            if let toast {
                ToastBanner(message: toast.message)
                    .padding(.bottom, 12)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(reduceMotion ? nil : .snappy(duration: 0.3), value: toast?.id)
        .task(id: toast?.id) {
            guard toast != nil else {
                return
            }

            try? await Task.sleep(for: .seconds(2))

            if toast != nil {
                toast = nil
            }
        }
        .sensoryFeedback(.warning, trigger: toast?.id) { _, newValue in
            newValue != nil
        }
        .toolbarBackground(.hidden, for: .navigationBar)
        .background {
            AppSpaceBackground()
                .ignoresSafeArea()
        }
        .navigationTitle("Hands of Time")
        .toolbar {
            ToolbarItemGroup(placement: .bottomBar) {
                Button {
                    withInputAnimation {
                        viewModel.undo()
                    }
                } label: {
                    Image(systemName: "arrow.counterclockwise")
                }
                .disabled(viewModel.values.isEmpty)
                .accessibilityLabel("Undo")

                Spacer()

                Button {
                    solvePuzzle()
                } label: {
                    Text("Solve")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .tint(.cyan)
                .disabled(!viewModel.canSolve)
            }
        }
        .toolbarBackground(.visible, for: .bottomBar)
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
            .padModalSheetPresentation()
        }
    }

    private var puzzleRingMaxWidth: CGFloat {
        horizontalSizeClass == .regular ? Self.puzzleRingMaxWidthRegular : Self.puzzleRingMaxWidthCompact
    }

    private func solvePuzzle() {
        switch viewModel.solve() {
        case let .solution(solution):
            modelContext.insert(PuzzleHistoryEntry(solution: solution))
            displayedSolution = DisplayedSolution(solution: solution)
        case .noSolution:
            toast = Toast(message: noSolutionToastMessage)
            AccessibilityNotification.Announcement(noSolutionToastMessage).post()
        case nil:
            break
        }
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

private struct Toast: Equatable {
    let id = UUID()
    let message: String
}

private struct ToastBanner: View {
    let message: String

    var body: some View {
        Text(message)
            .font(.subheadline.weight(.medium))
            .multilineTextAlignment(.center)
            .foregroundStyle(.white)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.black.opacity(0.72), in: Capsule())
            .overlay(
                Capsule()
                    .stroke(.white.opacity(0.2), lineWidth: 1)
            )
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
            .sensoryFeedback(.impact(weight: .light), trigger: configuration.isPressed) { _, isPressed in
                isPressed
            }
    }
}

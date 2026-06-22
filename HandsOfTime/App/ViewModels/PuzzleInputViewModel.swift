import Foundation
import HandsOfTimeCore
import Observation

@MainActor
@Observable
final class PuzzleInputViewModel {
    private(set) var values: [Int] = []
    var errorMessage: String?

    var canSolve: Bool {
        values.count >= 2
    }

    var displayString: String {
        values.map(String.init).joined()
    }

    func append(_ value: Int) {
        guard HandsOfTimePuzzle.allowedValues.contains(value) else {
            errorMessage = "Hands of Time values must be 1 through 6."
            return
        }

        guard values.count < HandsOfTimePuzzle.maximumCount else {
            errorMessage = "Hands of Time puzzles can contain at most \(HandsOfTimePuzzle.maximumCount) values."
            return
        }

        values.append(value)
        errorMessage = nil
    }

    func undo() {
        guard !values.isEmpty else {
            return
        }

        values.removeLast()
        errorMessage = nil
    }

    func solve() -> HandsOfTimeSolution? {
        guard canSolve else {
            errorMessage = "Enter at least two clock values."
            return nil
        }

        do {
            let puzzle = try HandsOfTimePuzzle(values: values)
            guard let solution = HandsOfTimeSolver.solve(puzzle) else {
                errorMessage = "No solution exists for this clock."
                return nil
            }

            errorMessage = nil
            return solution
        } catch {
            errorMessage = (error as? LocalizedError)?.errorDescription ?? "The puzzle could not be solved."
            return nil
        }
    }
}

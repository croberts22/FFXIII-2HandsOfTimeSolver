import Foundation
import HandsOfTimeCore
import Observation

enum SolveResult {
    case solution(HandsOfTimeSolution)
    case noSolution
}

@MainActor
@Observable
final class PuzzleInputViewModel {
    private(set) var values: [Int] = []

    var canSolve: Bool {
        values.count >= 2
    }

    var displayString: String {
        values.map(String.init).joined()
    }

    func append(_ value: Int) {
        guard HandsOfTimePuzzle.allowedValues.contains(value),
              values.count < HandsOfTimePuzzle.maximumCount
        else {
            return
        }

        values.append(value)
    }

    func undo() {
        guard !values.isEmpty else {
            return
        }

        values.removeLast()
    }

    func solve() -> SolveResult? {
        guard canSolve else {
            return nil
        }

        do {
            let puzzle = try HandsOfTimePuzzle(values: values)
            guard let solution = HandsOfTimeSolver.solve(puzzle) else {
                return .noSolution
            }

            return .solution(solution)
        } catch {
            return nil
        }
    }
}

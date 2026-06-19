import Foundation
import HandsOfTimeCore
import SwiftData

@Model
final class PuzzleHistoryEntry {
    @Attribute(.unique) var id: UUID
    var sequence: String
    var solutionPath: String
    var solvedAt: Date

    init(solution: HandsOfTimeSolution, solvedAt: Date = .now) {
        self.id = UUID()
        self.sequence = solution.values.map(String.init).joined()
        self.solutionPath = solution.path.map(String.init).joined(separator: ",")
        self.solvedAt = solvedAt
    }

    var values: [Int] {
        sequence.compactMap { Int(String($0)) }
    }

    var path: [Int] {
        solutionPath
            .split(separator: ",")
            .compactMap { Int($0) }
    }

    var solution: HandsOfTimeSolution? {
        guard !values.isEmpty, path.count == values.count else {
            return nil
        }

        return HandsOfTimeSolution(values: values, path: path)
    }
}

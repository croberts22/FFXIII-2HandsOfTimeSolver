import Foundation

public struct HandsOfTimePuzzle: Codable, Equatable, Hashable, Sendable {
    public static let maximumCount = 15
    public static let allowedValues = 1 ... 6

    public let values: [Int]

    public init(values: [Int]) throws {
        guard !values.isEmpty else {
            throw HandsOfTimeValidationError.emptyPuzzle
        }

        guard values.count <= Self.maximumCount else {
            throw HandsOfTimeValidationError.tooManyValues(maximum: Self.maximumCount)
        }

        if let invalidValue = values.first(where: { !Self.allowedValues.contains($0) }) {
            throw HandsOfTimeValidationError.invalidValue(invalidValue)
        }

        self.values = values
    }

    public static func parse(_ input: String) throws -> HandsOfTimePuzzle {
        let trimmed = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            throw HandsOfTimeValidationError.emptyPuzzle
        }

        let containsSeparators = trimmed.contains { character in
            character == "," || character.isWhitespace
        }

        let tokens: [String]
        if containsSeparators {
            tokens = trimmed
                .split(whereSeparator: { $0 == "," || $0.isWhitespace })
                .map(String.init)
        } else {
            tokens = trimmed.map { String($0) }
        }

        let values = try tokens.map { token in
            guard let value = Int(token) else {
                throw HandsOfTimeValidationError.invalidToken(token)
            }
            return value
        }

        return try HandsOfTimePuzzle(values: values)
    }

    public var displayString: String {
        values.map(String.init).joined()
    }
}

public enum HandsOfTimeValidationError: Error, Equatable, LocalizedError, Sendable {
    case emptyPuzzle
    case tooManyValues(maximum: Int)
    case invalidValue(Int)
    case invalidToken(String)

    public var errorDescription: String? {
        switch self {
        case .emptyPuzzle:
            "Enter at least one clock value."
        case let .tooManyValues(maximum):
            "Hands of Time puzzles can contain at most \(maximum) values."
        case let .invalidValue(value):
            "Hands of Time values must be 1 through 6. \(value) is not valid."
        case let .invalidToken(token):
            "\"\(token)\" is not a valid clock value."
        }
    }
}

public struct HandsOfTimeSolution: Codable, Equatable, Hashable, Sendable {
    public let values: [Int]
    public let path: [Int]

    public init(values: [Int], path: [Int]) {
        self.values = values
        self.path = path
    }

    public var steps: [SolutionStep] {
        path.indices.map { index in
            let currentIndex = path[index]
            let currentValue = values[currentIndex]

            guard index < path.index(before: path.endIndex) else {
                return SolutionStep(
                    ordinal: index + 1,
                    currentIndex: currentIndex,
                    currentValue: currentValue,
                    direction: .final,
                    nextIndex: nil,
                    nextValue: nil
                )
            }

            let nextIndex = path[index + 1]
            let direction: SolutionDirection
            if circularIndex(currentIndex - currentValue, count: values.count) == nextIndex {
                direction = .left
            } else {
                direction = .right
            }

            return SolutionStep(
                ordinal: index + 1,
                currentIndex: currentIndex,
                currentValue: currentValue,
                direction: direction,
                nextIndex: nextIndex,
                nextValue: values[nextIndex]
            )
        }
    }
}

public struct SolutionStep: Codable, Equatable, Hashable, Sendable {
    public let ordinal: Int
    public let currentIndex: Int
    public let currentValue: Int
    public let direction: SolutionDirection
    public let nextIndex: Int?
    public let nextValue: Int?

    public var instruction: String {
        switch direction {
        case .left:
            "Step \(ordinal): choose \(currentValue), then move left to \(nextValue ?? currentValue)."
        case .right:
            "Step \(ordinal): choose \(currentValue), then move right to \(nextValue ?? currentValue)."
        case .final:
            "Last step: choose the final node."
        }
    }
}

public enum SolutionDirection: String, Codable, Equatable, Hashable, Sendable {
    case left
    case right
    case final
}

public enum HandsOfTimeSolver {
    public static func solve(_ puzzle: HandsOfTimePuzzle) -> HandsOfTimeSolution? {
        let values = puzzle.values

        for startIndex in values.indices {
            var visited = Array(repeating: false, count: values.count)
            if let path = solve(from: startIndex, values: values, visited: &visited, path: []) {
                return HandsOfTimeSolution(values: values, path: path)
            }
        }

        return nil
    }

    private static func solve(
        from index: Int,
        values: [Int],
        visited: inout [Bool],
        path: [Int]
    ) -> [Int]? {
        guard !visited[index] else {
            return nil
        }

        var currentVisited = visited
        var currentPath = path
        currentVisited[index] = true
        currentPath.append(index)

        guard currentPath.count < values.count else {
            return currentPath
        }

        let moveValue = values[index]
        let leftIndex = circularIndex(index - moveValue, count: values.count)
        var leftVisited = currentVisited
        if let solution = solve(from: leftIndex, values: values, visited: &leftVisited, path: currentPath) {
            return solution
        }

        let rightIndex = circularIndex(index + moveValue, count: values.count)
        var rightVisited = currentVisited
        return solve(from: rightIndex, values: values, visited: &rightVisited, path: currentPath)
    }
}

public func circularIndex(_ index: Int, count: Int) -> Int {
    precondition(count > 0, "Cannot wrap an empty collection.")
    let remainder = index % count
    return remainder >= 0 ? remainder : remainder + count
}

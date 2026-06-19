import XCTest
@testable import HandsOfTimeCore

final class HandsOfTimeCoreTests: XCTestCase {
    func testParserAcceptsCompactDigits() throws {
        let puzzle = try HandsOfTimePuzzle.parse("11321")
        XCTAssertEqual(puzzle.values, [1, 1, 3, 2, 1])
        XCTAssertEqual(puzzle.displayString, "11321")
    }

    func testParserAcceptsWhitespaceAndCommaSeparatedInput() throws {
        XCTAssertEqual(try HandsOfTimePuzzle.parse("1 1 3 2 1").values, [1, 1, 3, 2, 1])
        XCTAssertEqual(try HandsOfTimePuzzle.parse("1,1, 3,2,1").values, [1, 1, 3, 2, 1])
    }

    func testParserRejectsEmptyInput() {
        XCTAssertThrowsError(try HandsOfTimePuzzle.parse("")) { error in
            XCTAssertEqual(error as? HandsOfTimeValidationError, .emptyPuzzle)
        }
    }

    func testParserRejectsInvalidValues() {
        XCTAssertThrowsError(try HandsOfTimePuzzle.parse("120")) { error in
            XCTAssertEqual(error as? HandsOfTimeValidationError, .invalidValue(0))
        }

        XCTAssertThrowsError(try HandsOfTimePuzzle.parse("7")) { error in
            XCTAssertEqual(error as? HandsOfTimeValidationError, .invalidValue(7))
        }
    }

    func testParserRejectsTooManyValues() {
        XCTAssertThrowsError(try HandsOfTimePuzzle.parse("1111111111111111")) { error in
            XCTAssertEqual(error as? HandsOfTimeValidationError, .tooManyValues(maximum: 15))
        }
    }

    func testSolverMatchesLegacyFixtures() throws {
        let fixtures: [(String, [Int])] = [
            ("11321", [0, 4, 3, 1, 2]),
            ("1251321125", [0, 9, 4, 1, 3, 2, 7, 8, 6, 5]),
            ("5411334221", [0, 5, 2, 3, 4, 1, 7, 9, 8, 6]),
            ("2424523122", [0, 2, 4, 9, 1, 5, 3, 7, 8, 6]),
            ("3124166626326", [8, 6, 0, 10, 7, 1, 2, 4, 3, 12, 5, 11, 9]),
            ("1352453361114", [6, 3, 5, 10, 9, 8, 2, 7, 4, 0, 1, 11, 12])
        ]

        for fixture in fixtures {
            let puzzle = try HandsOfTimePuzzle.parse(fixture.0)
            XCTAssertEqual(HandsOfTimeSolver.solve(puzzle)?.path, fixture.1, "Failed fixture \(fixture.0)")
        }
    }

    func testSolverReturnsNilForUnsolvablePuzzle() throws {
        let puzzle = try HandsOfTimePuzzle.parse("22")
        XCTAssertNil(HandsOfTimeSolver.solve(puzzle))
    }

    func testSolutionStepsDeriveDirectionsLeftFirst() throws {
        let puzzle = try HandsOfTimePuzzle.parse("11321")
        let solution = try XCTUnwrap(HandsOfTimeSolver.solve(puzzle))

        XCTAssertEqual(
            solution.steps,
            [
                SolutionStep(ordinal: 1, currentIndex: 0, currentValue: 1, direction: .left, nextIndex: 4, nextValue: 1),
                SolutionStep(ordinal: 2, currentIndex: 4, currentValue: 1, direction: .left, nextIndex: 3, nextValue: 2),
                SolutionStep(ordinal: 3, currentIndex: 3, currentValue: 2, direction: .left, nextIndex: 1, nextValue: 1),
                SolutionStep(ordinal: 4, currentIndex: 1, currentValue: 1, direction: .right, nextIndex: 2, nextValue: 3),
                SolutionStep(ordinal: 5, currentIndex: 2, currentValue: 3, direction: .final, nextIndex: nil, nextValue: nil)
            ]
        )
    }

    func testCircularIndexWrapsBothDirections() {
        XCTAssertEqual(circularIndex(-1, count: 5), 4)
        XCTAssertEqual(circularIndex(-6, count: 5), 4)
        XCTAssertEqual(circularIndex(5, count: 5), 0)
        XCTAssertEqual(circularIndex(8, count: 5), 3)
    }
}

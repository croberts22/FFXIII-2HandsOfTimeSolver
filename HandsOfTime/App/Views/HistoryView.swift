import HandsOfTimeCore
import SwiftData
import SwiftUI

struct HistoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \PuzzleHistoryEntry.solvedAt, order: .reverse) private var entries: [PuzzleHistoryEntry]

    var body: some View {
        Group {
            if entries.isEmpty {
                ContentUnavailableView(
                    "No Solved Clocks",
                    systemImage: "clock.badge.questionmark",
                    description: Text("Solved puzzles will appear here.")
                )
            } else {
                List {
                    ForEach(entries) { entry in
                        if let solution = entry.solution {
                            NavigationLink(value: solution) {
                                HistoryRow(entry: entry)
                            }
                        }
                    }
                    .onDelete(perform: deleteEntries)
                }
            }
        }
        .navigationTitle("History")
        .navigationDestination(for: HandsOfTimeSolution.self) { solution in
            SolutionView(solution: solution)
        }
    }

    private func deleteEntries(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(entries[index])
        }
    }
}

private struct HistoryRow: View {
    let entry: PuzzleHistoryEntry

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(entry.sequence)
                .font(.headline.monospacedDigit())

            Text(entry.solvedAt, style: .date)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Puzzle \(entry.sequence), solved \(entry.solvedAt.formatted(date: .abbreviated, time: .shortened))")
    }
}

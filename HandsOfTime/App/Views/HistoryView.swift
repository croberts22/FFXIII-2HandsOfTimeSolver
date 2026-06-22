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
                            NavigationLink {
                                SolutionView(solution: solution)
                            } label: {
                                HistoryRow(entry: entry)
                            }
                        }
                    }
                    .onDelete(perform: deleteEntries)
                    .listRowBackground(Color.clear)
                }
                .scrollContentBackground(.hidden)
            }
        }
        .background {
            AppSpaceBackground()
                .ignoresSafeArea()
        }
        .navigationTitle("History")
        .navigationBarTitleDisplayMode(.inline)
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

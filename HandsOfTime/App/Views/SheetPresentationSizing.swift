import SwiftUI

private struct PadModalSheetSizing: PresentationSizing {
    func proposedSize(for _: PresentationSizingRoot, context _: PresentationSizingContext) -> ProposedViewSize {
        ProposedViewSize(width: 680, height: 820)
    }
}

extension PresentationSizing where Self == PadModalSheetSizing {
    static var padModal: PadModalSheetSizing { PadModalSheetSizing() }
}

extension View {
    func padModalSheetPresentation() -> some View {
        presentationSizing(.padModal)
    }
}

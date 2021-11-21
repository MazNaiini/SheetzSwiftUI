//
//  Created by Maz Naiini on 2021-11-13.
//

import SwiftUI

public struct FormSheetView<Content: View>: View {
    @ViewBuilder public let content: Content
    public var onDismissAction: () -> Void
    
    @State private var isShown = false
    @State private var chromeAlpha: CGFloat = 0
    @State private var dragYOffset: CGFloat = 0
        
    public var body: some View {
        GeometryReader { geometry in
            ZStack() {
                Chrome(chromeAlpha: $chromeAlpha)
                    .onTapGesture{
                        dismissWithAnimation(animation: .easeOut)
                    }
                content
                    .formSheet(
                        width: Constants.sheetWidth,
                        backgroundColor: .white,
                        isShown: $isShown
                    ) {
                        dismissWithAnimation(animation: .easeOut)
                    }
                    .offset(y: dragYOffset)
                    .gesture(
                        getDragGesture(totalHeight: geometry.totalHeight)
                    )
            }
            .onAppear(perform: presentWithAnimation)
            .onAnimationCompleted(for: chromeAlpha) {
                if chromeAlpha == 0 {
                    onDismissAction()
                }
            }
        }
    }
    
    private func getDragGesture(
        totalHeight: CGFloat
    ) -> _EndedGesture<_ChangedGesture<DragGesture>> {
        DragGesture()
            .onChanged {
                onDragChanged(value: $0, geometryHeight: totalHeight)
            }
            .onEnded {
                onDragEnded(value: $0, geometryHeight: totalHeight)
            }
    }
    
    private func onDragChanged(value: DragGesture.Value, geometryHeight: CGFloat) {
        let yTranslation = max(value.translation.height, 0)
        dragYOffset = yTranslation
        chromeAlpha = ((geometryHeight - yTranslation)/geometryHeight) * Constants.chromeAlpha
    }
    
    private func onDragEnded(value: DragGesture.Value, geometryHeight: CGFloat) {
        guard value.predictedEndTranslation.height < geometryHeight / 3 else {
            dismissWithAnimation(animation: .linear(duration: 0.15))
            return
        }

        if value.translation.height < geometryHeight / 4 {
            withAnimation(.easeOut) {
                dragYOffset = 0
                chromeAlpha = Constants.chromeAlpha
            }
        } else {
            dismissWithAnimation(animation: .easeInOut)
        }
    }
    
    private func presentWithAnimation() {
        withAnimation(.easeIn) {
            isShown = true
            chromeAlpha = Constants.chromeAlpha
        }
    }
    
    private func dismissWithAnimation(animation: Animation = .easeOut) {
        withAnimation(animation) {
            isShown = false
            chromeAlpha = 0
        }
    }
    
}

private struct Constants {
    static let chromeAlpha: CGFloat = 0.6
    static let sheetWidth: CGFloat = 350
}

struct FormSheetView_Previews: PreviewProvider {
    static var previews: some View {
        FormSheetView {
            ContentView(
                viewModel: .init(
                    settings: [
                        .init(title: "Yellow Card", selected: true),
                        .init(title: "Red card", selected: false),
                        .init(title: "Penalty", selected: true),
                        .init(title: "Corner", selected: false),
                        .init(title: "Full time", selected: true)
                    ]
                )
            )
        } onDismissAction: {
        }
    }
}

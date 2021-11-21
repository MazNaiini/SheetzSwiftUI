//
//  Created by Maz Naiini on 2021-11-10.
//

import SwiftUI

struct BottomSheetView<Content: View>: View {
    @ViewBuilder let content: Content
    var onDismissAction: () -> Void
    
    @State private var isShown = false
    @State private var chromeAlpha: CGFloat = 0
    @State private var dragYOffset: CGFloat = 0
    @State private var sheetHeight: CGFloat = 0
    
    var body: some View {
        ZStack {
            Chrome(chromeAlpha: $chromeAlpha)
                .onTapGesture(
                    perform: {
                        dismissWithAnimation(animation: .easeOut)
                    }
                )
            content
                .bottomSheet(
                    isShown: $isShown,
                    sheetHeight: $sheetHeight,
                    backGroundColor: Color(UIColor.systemBackground)
                )
                .offset(y: dragYOffset)
                .gesture(
                    DragGesture()
                        .onChanged(onDragChanged)
                        .onEnded(onDragEnded)
                )
        }
        .onAppear(perform: presentWithAnimation)
        .onAnimationCompleted(for: chromeAlpha) {
            if chromeAlpha == 0 {
                onDismissAction()
            }
        }
    }
    
    private func onDragChanged(value: DragGesture.Value) -> Void {
        let yTranslation = max(value.translation.height, 0)
        dragYOffset = yTranslation
        chromeAlpha = ((sheetHeight - yTranslation)/sheetHeight) * Constants.maxChromeAlpha
    }
    
    private func onDragEnded(value: DragGesture.Value) -> Void {
        guard value.predictedEndTranslation.height < sheetHeight / 3 else {
            dismissWithAnimation(animation: .linear(duration: 0.15))
            return
            
        }
        
        if value.translation.height < sheetHeight / 2 {
            withAnimation(.easeOut) {
                dragYOffset = 0
                chromeAlpha = Constants.maxChromeAlpha
            }
        } else {
            dismissWithAnimation(animation: .easeInOut)
        }
    }
    
    private func presentWithAnimation() {
        withAnimation(.easeInOut) {
            chromeAlpha = Constants.maxChromeAlpha
            isShown = true
        }
    }
    
    private func dismissWithAnimation(animation: Animation) {
        withAnimation(animation) {
            chromeAlpha = 0
            isShown = false
        }
    }
}

private struct Constants {
    static let maxChromeAlpha: CGFloat = 0.6
}

struct SheetViewWithModifier_Previews: PreviewProvider {
    static var previews: some View {
        BottomSheetView {
            ContentView(
                viewModel: .init(
                    settings: [
                        .init(title: "Setting One", selected: true),
                        .init(title: "Setting Two", selected: false),
                        .init(title: "Setting Three", selected: true),
                        .init(title: "Setting Four", selected: false),
                        .init(title: "Setting Five", selected: true)
                    ]
                )
            )
        } onDismissAction: {
        }
    }
}

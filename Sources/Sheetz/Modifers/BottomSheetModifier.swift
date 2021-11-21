//
//  Created by Maz Naiini on 2021-11-10.
//

import SwiftUI

struct BottomSheetModifier: ViewModifier {
    @Binding var isShown: Bool
    @Binding var sheetHeight: CGFloat

    let backgroundColor: Color
    
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                Spacer()
                    .frame(height: isShown ? nil : geometry.totalHeight)
                    .measureSize { size in
                        sheetHeight = geometry.totalHeight - size.height
                    }
                VStack {
                    Capsule(style: .circular)
                        .frame(width: 64, height: 4)
                        .foregroundColor(Color(white: 0.3))
                        .padding([.top, .bottom], 8)
                    content
                }
                .padding(.bottom, geometry.safeAreaInsets.bottom)
                .background(backgroundColor)
                .cornerRadius(radius: 25, corners: [.topLeft, .topRight])
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
    
    private var animation: Animation {
        .interpolatingSpring(
            stiffness: 300.0,
            damping: 30.0,
            initialVelocity: 10.0
        ).delay(0.1)
    }
}

extension View {
    func bottomSheet(
        isShown: Binding<Bool>,
        sheetHeight: Binding<CGFloat>,
        backgroundColor: Color
    ) -> some View {
        ModifiedContent(
            content: self,
            modifier: BottomSheetModifier(
                isShown: isShown,
                sheetHeight: sheetHeight,
                backgroundColor: backgroundColor
            )
        )
    }
}

struct BottomSheetViewModifier_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16){
            Text("LOREM IPSUM")
                .font(.headline)
            Divider()
                .padding([.leading, .trailing], 16)
            ForEach(0..<3) { index in
                Text("This item number \(index)")
                    .padding(.bottom, 8)
            }
        }
        .bottomSheet(
            isShown: .constant(true),
            sheetHeight: .constant(0),
            backgroundColor: Color(white: 1)
        )
        .background(Color.gray)
        .edgesIgnoringSafeArea(.top)
    }
}

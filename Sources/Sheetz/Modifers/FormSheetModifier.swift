//
//  Created by Maz Naiini on 2021-11-13.
//

import SwiftUI

struct FormSheetModifier: ViewModifier {
    let width: CGFloat
    let backgroundColor: Color
    let onCloseTapped: () -> Void
    @Binding var isShown: Bool

    func body(content: Content) -> some View {
        GeometryReader { geometry in
            HStack {
                let geometryWidth = geometry.size.width
                if width <= geometryWidth {
                    Spacer()
                }
                VStack {
                    Spacer()
                        .frame(
                            height: isShown ? nil: geometry.totalHeight
                        )
                    getSheetContent(
                        with: content,
                        maxWidth: geometry.size.width
                    )
                    Spacer()
                        .frame(height: isShown ? nil: 0)
                }
                .edgesIgnoringSafeArea(.all)
                if width <= geometryWidth {
                    Spacer()
                }
            }
        }
    }
    
    private func getSheetContent(
        with content: Content,
        maxWidth: CGFloat
    ) -> some View {
        VStack {
            getTopBar(onClose: onCloseTapped)
            content
        }
        .padding()
        .frame(width: min(width, maxWidth))
        .background(backgroundColor)
        .cornerRadius(20)
    }
    
    private func getTopBar(onClose: @escaping () -> Void) -> some View {
        HStack {
            Spacer()
            Button {
                onClose()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color(.black))
                    .font(.system(size: 25))
            }
        }
    }
}

extension View {
    func formSheet(
        width: CGFloat,
        backgroundColor: Color,
        isShown: Binding<Bool>,
        onClose: @escaping () -> Void
    ) -> some View {
        ModifiedContent(
            content: self,
            modifier: FormSheetModifier(
                width: width,
                backgroundColor: backgroundColor,
                onCloseTapped: onClose,
                isShown: isShown
            )
        )
    }
}

struct FormSheetModifier_Preview: PreviewProvider {
    static var previews: some View {
        VStack(spacing: 16) {
            Text("LOREM IPSUM")
                .font(.headline)
            Divider()
                .padding([.leading, .trailing], 16)
            ForEach(0..<3) { index in
                Text("This item number \(index)")
                    .padding(.bottom, 8)
            }
        }
        .formSheet(
            width: 400,
            backgroundColor: .yellow,
            isShown: .constant(true),
            onClose: {}
        )
        .background(Color.gray)
        .edgesIgnoringSafeArea(.all)
    }
}

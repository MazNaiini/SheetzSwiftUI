//
//  Created by Maz Naiini on 2021-11-13.
//

import SwiftUI

struct FormSheetModifier: ViewModifier {
    let width: CGFloat
    var onCloseTapped: () -> Void
    @Binding var isShown: Bool
        
    func body(content: Content) -> some View {
        GeometryReader { geometry in
            HStack {
                Spacer()
                VStack {
                    Spacer()
                        .frame(height: isShown ? nil: geometry.totalHeight)
                    getSheetContent(with: content)
                    Spacer()
                        .frame(height: isShown ? nil: 0)
                }
                .edgesIgnoringSafeArea(.all)
                Spacer()
            }
        }
    }
    
    private func getSheetContent(with content: Content) -> some View {
        VStack {
            getTopBar(onClose: onCloseTapped)
            content
        }
        .frame(width: width)
        .padding()
        .background(Color(white: 1))
        .cornerRadius(20)
    }
    
    private func getTopBar(onClose: @escaping () -> Void) -> some View {
        HStack {
            Spacer()
            Button {
                onClose()
            } label: {
                Image(systemName: "xmark")
                    .foregroundColor(Color(UIColor.white))
                    .font(.system(size: 25))
            }
        }
    }
}

extension View {
    func formSheet(width: CGFloat, isShown: Binding<Bool>, onClose: @escaping () -> Void) -> some View {
        ModifiedContent(content: self,
            modifier: FormSheetModifier(
                width: width,
                onCloseTapped: onClose,
                isShown: isShown
            )
        )
    }
}

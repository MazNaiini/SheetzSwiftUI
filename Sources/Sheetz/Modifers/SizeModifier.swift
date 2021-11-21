//
//  Created by Maz Naiini on 2021-11-12.
//

import SwiftUI

private struct SizeKey: PreferenceKey {
    static var defaultValue = CGSize.zero

    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {
        value = nextValue()
    }
}

private struct SizeModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.background(
            GeometryReader { geometry in
                Color.clear
                    .preference(key: SizeKey.self, value: geometry.size)
            }
        )
    }
}

extension View {
    func measureSize(completion: @escaping (CGSize) -> Void) -> some View {
        modifier(SizeModifier())
            .onPreferenceChange(SizeKey.self) { size in
                completion(size)
            }
    }
}

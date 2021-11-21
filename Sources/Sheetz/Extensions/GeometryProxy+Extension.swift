//
//  Created by Maz Naiini on 2021-11-10.
//

import SwiftUI

extension GeometryProxy {
    var totalHeight: CGFloat {
        size.height + safeAreaInsets.top + safeAreaInsets.bottom
    }
}

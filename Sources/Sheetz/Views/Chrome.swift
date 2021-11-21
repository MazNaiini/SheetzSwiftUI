//
//  Created by Maz Naiini on 2021-11-13.
//

import SwiftUI

struct Chrome: View {
    @Binding var chromeAlpha: CGFloat
    
    var body: some View {
        Color(.gray)
            .opacity(chromeAlpha)
            .edgesIgnoringSafeArea(.all)
    }
}

struct Chrome_Previews: PreviewProvider {
    static var previews: some View {
        Chrome(chromeAlpha: .constant(0.3))
    }
}

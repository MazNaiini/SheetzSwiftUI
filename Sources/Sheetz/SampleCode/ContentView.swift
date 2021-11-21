//
//  Created by Maz Naiini on 2021-11-10.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Lorem Ipsum")
                .font(.headline)
            Divider()
            ForEach($viewModel.settings) { $setting in
                Toggle(setting.title, isOn: $setting.selected)
            }
        }
        .padding([.leading, .trailing], 16)
        .padding([.top, .bottom], 8)
    }
}

struct PushNotificationSubscriptionsSheet_Preview: PreviewProvider {
    static var previews: some View {
        ZStack {
            Color.gray.edgesIgnoringSafeArea(.all)
            ContentView(
                viewModel: .init(settings: [
                    .init(title: "Setting I", selected: true),
                    .init(title: "Setting II", selected: false),
                    .init(title: "Setting III", selected: true),
                    .init(title: "Setting IV", selected: false),
                    .init(title: "Setting V", selected: true)
                ])
            )
                .background(Color.white)
        }
    }
}

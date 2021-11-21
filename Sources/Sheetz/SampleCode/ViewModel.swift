//
//  Created by Maz Naiini on 2021-11-10.
//

import Foundation

/// The view model used for the PushNotificationSubscriptionsSheet view
class ViewModel: ObservableObject {
    @Published var settings: [Setting]

    init(settings: [Setting]) {
        self.settings = settings
    }
}


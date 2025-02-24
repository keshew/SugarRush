import SwiftUI

class SugarShopViewModel: ObservableObject {
    let contact = SugarShopModel()
    @Published var ud = UserDefaultsManager()
    @Published var again = 0
}

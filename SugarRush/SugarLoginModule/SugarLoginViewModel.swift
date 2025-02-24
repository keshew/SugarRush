import SwiftUI

class SugarLoginViewModel: ObservableObject {
    let contact = SugarLoginModel()
    @Published var isMenu = false
}

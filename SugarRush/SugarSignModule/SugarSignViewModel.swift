import SwiftUI

class SugarSignViewModel: ObservableObject {
    let contact = SugarSignModel()
    @Published var isLog = false
}

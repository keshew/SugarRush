import SwiftUI

class SugarLoadingViewModel: ObservableObject {
    let contact = SugarLoadingModel()
    @Published var currentIndex = 0
    @Published var isMenu = false
    @Published var isSign = false
}

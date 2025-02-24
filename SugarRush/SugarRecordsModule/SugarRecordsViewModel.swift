import SwiftUI

class SugarRecordsViewModel: ObservableObject {
    let contact = SugarRecordsModel()
    @Published var currentIndex = 0
    @Published var indexInCycle = 0
    
    func increaseIndex() {
        currentIndex += 1
        indexInCycle += 4
    }
    
    func lowerIndex() {
        currentIndex -= 1
        indexInCycle -= 4
    }
}

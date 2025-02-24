import SwiftUI

class SugarWorldRecordsViewModel: ObservableObject {
    let contact = SugarWorldRecordsModel()
    @Published var indexInCycle = 0
    @Published var currentIndex = 0
    @Published var records: [Record2] = []
    
    func increaseIndex() {
        currentIndex += 1
        indexInCycle += 4
    }
    
    func lowerIndex() {
        currentIndex -= 1
        indexInCycle -= 4
    }
    
    func loadAllRecords() {
            APIManager().getAllRecords { result in
                switch result {
                case .some(let response):
                    if let data = response.data {
                        DispatchQueue.main.async {
                            self.records = data
                        }
                    }
                case .none:
                    print("Нет данных")
                }
                DispatchQueue.main.async {
                    self.currentIndex = 0
                    self.indexInCycle = 0
                }
            }
        }
}


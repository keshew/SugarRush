import SwiftUI

class SugarMyRecordsViewModel: ObservableObject {
    @Published var records: [Int] = []
    @Published var indexInCycle = 0
    @Published var currentIndex = 0
    @Published var username: String = ""
    
    func increaseIndex() {
        currentIndex += 1
        indexInCycle += 4
    }
    
    func lowerIndex() {
        currentIndex -= 1
        indexInCycle -= 4
    }
    
    func loadRecords() {
        let credentials = UserDefaultsManager().getUserCredentials()
        APIManager().getUserRecords(login: credentials.login!, pass: credentials.password!) { result in
            switch result {
            case .success(let response):
                    if let data = response.data {
                        DispatchQueue.main.async {
                        self.records = data.sorted { $0 > $1 }
                        self.username = credentials.login!
                    }
                }
            case .failure(let error):
                switch error {
                case .invalidStatusCode(let code):
                    print("Error: Invalid HTTP status code \(code)")
                case .decodingFailed(let decodingError):
                    print("Error: JSON decoding failed: \(decodingError)")
                case .requestFailed(let requestError):
                    print("Error: Request failed: \(requestError)")
                case .noDataReceived:
                    print("Error: No data received")
                }
            }
            DispatchQueue.main.async {
                self.currentIndex = 0
                self.indexInCycle = 0
            }
        }
    }
}


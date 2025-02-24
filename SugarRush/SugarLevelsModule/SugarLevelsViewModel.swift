import SwiftUI

class SugarLevelsViewModel: ObservableObject {
    let contact = SugarLevelsModel()
    let columns = [
          GridItem(.flexible(), spacing: -40),
          GridItem(.flexible(), spacing: -40),
          GridItem(.flexible(), spacing: -40)
      ]
}

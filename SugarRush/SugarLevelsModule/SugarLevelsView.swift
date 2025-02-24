import SwiftUI

struct SugarLevelsView: View {
    @StateObject var sugarLevelsModel =  SugarLevelsViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.mainBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                ForegroundView(geometry: geometry, name: "levels")
                
                VStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        BackButton(geometry: geometry)
                    }
                    
                    Spacer()
                    
                    LazyVGrid(columns: sugarLevelsModel.columns, spacing: 40) {
                        ForEach(0..<12, id: \.self) { index in
                            if UserDefaultsManager.defaults.integer(forKey: Keys.currentLevel.rawValue) <= index {
                                LevelButton(geometry: geometry,
                                            image: SugarImageName.closedLevel.rawValue,
                                            text: "\(index + 1)")
                            } else {
                                NavigationLink(destination: SugarGameView(level: index + 1)) {
                                    LevelButton(geometry: geometry,
                                                image: SugarImageName.squareButtonBackground.rawValue,
                                                text: "\(index + 1)")
                                }
                            }
                        }
                    }
                    .padding(.top, geometry.size.height * 0.132)
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SugarLevelsView()
}


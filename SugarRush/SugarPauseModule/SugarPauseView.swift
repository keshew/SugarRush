import SwiftUI
import SpriteKit

struct SugarPauseView: View {
    @StateObject var sugarPauseModel =  SugarPauseViewModel()
    var game: SugarGameData
    var scene: SKScene
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                ForegroundView(geometry: geometry, name: "PAUSE")
                
                VStack {
                    ZStack {
                        SettingsRectangle(geometry: geometry)
                        
                        Text("Get some rest,\nyour game is on\npause")
                            .Bowlby(size: 25)
                            .multilineTextAlignment(.center)
                    }
                    
                    HStack {
                        NavigationLink(destination: SugarMenuView()) {
                            ZStack {
                                Image(.wideButtonBackground)
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.418, height: geometry.size.height * 0.099)
                                
                                Text("MENU")
                                    .Bowlby(size: 20)
                            }
                        }
                        
                        Button(action: {
                            game.isPause = false
                            scene.isPaused = false
                        }) {
                            ZStack {
                                Image(.wideButtonBackground)
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.418, height: geometry.size.height * 0.099)
                                
                                Text("CONTINUE!")
                                    .Bowlby(size: 20)
                            }
                        }
                    }
                    .offset(y: -geometry.size.height * 0.022)
                }
                .offset(y: geometry.size.height * 0.148)
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    let game = SugarGameData()
    return SugarPauseView(game: game, scene: game.scene)
}


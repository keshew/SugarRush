import SwiftUI
import SpriteKit

struct SugarRulesView: View {
    @StateObject var sugarRulesModel =  SugarRulesViewModel()
    var game: SugarGameData
    var scene: SKScene
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                ForegroundView(geometry: geometry, name: "RULES")
                
                VStack {
                    Spacer()
                    
                    ZStack {
                        SettingsRectangle(geometry: geometry)
                        
                        Text("The goal is to clear the playing\nfield of bricks.Add bricks from the\nsides so that bricks of the same color\nare grouped together.Groups of\nthree or morebricks of the same color\nare removed, earning points. Each\nlevel is harder than the previous one.\nUse the limited hammers in the\nbottom right corner to remove\nobstructing bricks.")
                            .Bowlby(size: 13)
                            .multilineTextAlignment(.center)
                    }
                    .offset(y: geometry.size.height * 0.151)
                    
                    Button(action: {
                        game.isRules = false
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
                    .offset(y: geometry.size.height * 0.119)
                    
                    Spacer()
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    let game = SugarGameData()
    return SugarRulesView(game: game, scene: game.scene)
}


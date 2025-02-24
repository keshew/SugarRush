import SwiftUI

struct SugarLoseView: View {
    @ObservedObject var audioManager = AudioManager.shared
    @StateObject var sugarLoseModel =  SugarLoseViewModel()
    let level: Int
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                ForegroundView(geometry: geometry, name: "LOSE")
                
                VStack {
                    ZStack {
                        SettingsRectangle(geometry: geometry)
                        
                        Text("Unfortunately,\nthe time is over\nand you didn't\nhave time to\nscore points,\ntry again!")
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
                        
                        NavigationLink(destination: SugarGameView(level: level)) {
                            ZStack {
                                Image(.wideButtonBackground)
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.418, height: geometry.size.height * 0.099)
                                
                                Text("RETRY!")
                                    .Bowlby(size: 20)
                            }
                        }
                    }
                    .offset(y: -geometry.size.height * 0.022)
                }
                .offset(y: geometry.size.height * 0.148)
            }
            
            .onAppear {
                audioManager.stopBackgroundMusic()
                audioManager.playLoseMusic()
            }
            
            .onDisappear() {
                audioManager.stopLoseMusic()
                audioManager.playBackgroundMusic()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    SugarLoseView(level: 1)
}


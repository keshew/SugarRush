import SwiftUI

struct SugarWinView: View {
    @StateObject var sugarWinModel =  SugarWinViewModel()
    @State private var text: String = ""
    @ObservedObject var audioManager = AudioManager.shared
    @State private var isSetted = false
    let service = APIManager()
    let level: Int
    let point: Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Color(.black)
                    .opacity(0.5)
                    .ignoresSafeArea()
                
                ForegroundView(geometry: geometry, name: "VICTORY")
                
                VStack {
                    ZStack {
                        SettingsRectangle(geometry: geometry)
                        VStack(spacing: geometry.size.height * 0.037) {
                            VStack(spacing: geometry.size.height * 0.022) {
                                Text("Congratulations, you\npassed the level and\nscored points.")
                                    .Bowlby(size: 15)
                                    .multilineTextAlignment(.center)
                                
                                HStack {
                                    Text("YOUR WINNINGS: 30")
                                        .Bowlby(size: 20)
                                    
                                    Image(.candyForeground)
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.076, height: geometry.size.width * 0.076)
                                        .offset(y: -geometry.size.height * 0.003)
                                }
                            }
                            
                            Button(action: {
                                let credentials = UserDefaultsManager().getUserCredentials()
                                if let login = credentials.login, let password = credentials.password {
                                    service.saveUserRecord(login: login, pass: password, record: "\(point)") { response in
                                        if let response = response {
                                            if response.status == "success" {
                                                print("Record saved successfully!")
                                            } else {
                                                print("Failed to save record:", response.message)
                                            }
                                        } else {
                                            print("Server is busy now.")
                                        }
                                    }
                                } else {
                                    print("No user credentials found.")
                                }

                            }) {
                                ZStack {
                                    Image(.wideButtonBackground)
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.329, height: geometry.size.height * 0.078)
                                    
                                    Text("SET RECORD!")
                                        .Bowlby(size: 12)
                                }
                            }
                        }
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
                        
                        NavigationLink(destination: SugarGameView(level: level + 1)) {
                            ZStack {
                                Image(.wideButtonBackground)
                                    .resizable()
                                    .frame(width: geometry.size.width * 0.418, height: geometry.size.height * 0.099)
                                
                                Text("NEXT!")
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
        
        .onAppear {
            audioManager.stopBackgroundMusic()
            audioManager.playWinMusic()
        }
        
        .onDisappear() {
            audioManager.stopWinMusic()
            audioManager.playBackgroundMusic()
        }
    }
}


#Preview {
    SugarWinView(level: 1, point: 500)
}


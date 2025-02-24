import SwiftUI

struct SugarMenuView: View {
    @StateObject var sugarMenuModel =  SugarMenuViewModel()
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.mainBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                ForegroundViewMenu(geometry: geometry, coin: "COIN: \(UserDefaultsManager.defaults.integer(forKey: Keys.money.rawValue))")
                
                VStack {
                    HStack {
                        Spacer()
                        NavigationLink(destination: SugarSettingsView()) {
                            VStack(spacing: 0) {
                                ZStack {
                                    Image(.squareButtonBackground)
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.196,
                                               height: geometry.size.height * 0.097)
                                    
                                    Image(.gearForeground)
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.103,
                                               height: geometry.size.width * 0.103)
                                }
                                Text("settings")
                                    .Bowlby(size: 15, outlineWidth: 0.5)
                            }
                            .padding(.trailing)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: geometry.size.height * 0.027) {
                        NavigationLink(destination: SugarLevelsView()) {
                            PlayButton(geometry: geometry)
                        }
                        
                        VStack(spacing: geometry.size.height * 0.0135) {
                            NavigationLink(destination: SugarShopView()) {
                                ShopButton(geometry: geometry)
                            }
                            
                            NavigationLink(destination: SugarRecordsView()) {
                                RecordsButton(geometry: geometry)
                            }
                        }
                    }
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 1.68)
                }
            }
            
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SugarMenuView()
}

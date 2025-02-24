import SwiftUI

struct SugarShopView: View {
    @StateObject var sugarShopModel =  SugarShopViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.mainBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                ShopForegroundView(geometry: geometry, coin: "COIN:\(UserDefaultsManager.defaults.object(forKey: Keys.money.rawValue) as? Int ?? 0)")
                
                VStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        BackButton(geometry: geometry)
                    }
                    
                    Spacer()
                    
                    
                    VStack(spacing: geometry.size.height * 0.0925) {
                            ZStack {
                                ShopItem(geometry: geometry,
                                         image: SugarImageName.hummer.rawValue,
                                         name: "BLOCK BREAKER")
                                Button(action: {
                                    sugarShopModel.ud.buyBonus(key: Keys.hummerCount.rawValue)
                                    sugarShopModel.again = 1
                                }) {
                                    ZStack {
                                        Image(.wideButtonBackground)
                                            .resizable()
                                            .frame(width: 117, height: 47)
                                        
                                        Text("NEXT!")
                                            .Bowlby(size: 15)
                                    }
                                }
                                .offset(y: geometry.size.height * 0.131)
                            }
                            
                            
                            ZStack {
                                ShopItem(geometry: geometry,
                                         image: SugarImageName.time.rawValue,
                                         imageSizeW: 0.16,
                                         imageSizeH: 0.09,
                                         name: "BONUS TIME")
                                
                                Button(action: {
                                    sugarShopModel.ud.buyBonus(key: Keys.timeCount.rawValue)
                                    sugarShopModel.again = 1
                                }) {
                                    ZStack {
                                        Image(.wideButtonBackground)
                                            .resizable()
                                            .frame(width: 117, height: 47)
                                        
                                        Text("NEXT!")
                                            .Bowlby(size: 15)
                                    }
                                }
                                .offset(y: geometry.size.height * 0.131)
                            }
                        }
                        .padding(.bottom)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SugarShopView()
}

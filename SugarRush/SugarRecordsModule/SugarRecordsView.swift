import SwiftUI

struct SugarRecordsView: View {
    @StateObject var sugarRecordsModel =  SugarRecordsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.mainBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                ForegroundView(geometry: geometry, name: "records")
                
                VStack {
                    HStack {
                        NavigationLink(destination: SugarMenuView()) {
                            BackButton(geometry: geometry)
                        }
                        
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
                                               height: geometry.size.height * 0.053)
                                }
                                Text("settings")
                                    .Bowlby(size: 15, outlineWidth: 0.5)
                            }
                            .padding(.trailing)
                        }
                    }
                    
                    Spacer()
                    
                    VStack(spacing: 50) {
                        if UserDefaultsManager().getLoginStatus() {
                            NavigationLink(destination: SugarMyRecordsView()) {
                                ZStack {
                                    Image(.wideButtonBackground)
                                        .resizable()
                                        .frame(width: 237, height: 96)
                                    
                                    Text("MY\nRECORDS")
                                        .Bowlby(size: 20)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        } else {
                            NavigationLink(destination: SugarSignView()) {
                                ZStack {
                                    Image(.wideButtonBackground)
                                        .resizable()
                                        .frame(width: 237, height: 96)
                                    
                                    Text("MY\nRECORDS")
                                        .Bowlby(size: 20)
                                        .multilineTextAlignment(.center)
                                }
                            }
                        }
                       
                        
                        NavigationLink(destination: SugarWorldRecordsView()) {
                            ZStack {
                                Image(.wideButtonBackground)
                                    .resizable()
                                    .frame(width: 237, height: 96)
                                
                                Text("WORLD\nRECORDS")
                                    .Bowlby(size: 20)
                                    .multilineTextAlignment(.center)
                            }
                        }
                    }
                    .padding(.bottom, 110)
                    
                    
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SugarRecordsView()
}


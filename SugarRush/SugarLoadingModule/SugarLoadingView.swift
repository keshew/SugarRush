import SwiftUI

struct SugarLoadingView: View {
    @StateObject var sugarLoadingModel =  SugarLoadingViewModel()
    @ObservedObject var audioManager = AudioManager.shared
    var body: some View {
        NavigationView {
        GeometryReader { geometry in
                ZStack {
                    Image(.mainBackground)
                        .resizable()
                        .ignoresSafeArea()
                    
                    VStack {
                        Spacer()
                        
                        Text("LOADING...")
                            .Bowlby(size: 40)
                        
                        ZStack {
                            Rectangle()
                                .fill(.black)
                                .frame(width: geometry.size.width * 0.797, height: 30)
                                .cornerRadius(20)
                            
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        gradient: Gradient(colors: [Color(red: 73/255, green: 2/255, blue: 64/255),
                                                                    Color(red: 255/255, green: 0/255, blue: 222/255)]),
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: geometry.size.width * sugarLoadingModel.contact.widthArray[sugarLoadingModel.currentIndex]
                                       , height: 23)
                                .cornerRadius(20)
                                .offset(x: geometry.size.width * sugarLoadingModel.contact.offsetArray[sugarLoadingModel.currentIndex])
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        sugarLoadingModel.currentIndex += 1
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        sugarLoadingModel.currentIndex += 1
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                        audioManager.playBackgroundMusic()
//                        if UserDefaultsManager().getLoginStatus() {
//                            sugarLoadingModel.isMenu = true
//                        } else {
//                            sugarLoadingModel.isSign = true
//                        }
                        sugarLoadingModel.isMenu = true
                    }
                }
                
                NavigationLink(destination: SugarMenuView(),
                               isActive: $sugarLoadingModel.isMenu) {}
                .hidden()
            
            
            NavigationLink(destination: SugarSignView(),
                           isActive: $sugarLoadingModel.isSign) {}
            .hidden()
            }
        }
    }
}

#Preview {
    SugarLoadingView()
}

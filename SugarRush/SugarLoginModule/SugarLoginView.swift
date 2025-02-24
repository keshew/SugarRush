import SwiftUI

struct SugarLoginView: View {
    @StateObject var sugarLoginModel =  SugarLoginViewModel()
    @State private var nickname: String = ""
    @State private var password: String = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    let service = APIManager()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.mainBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                ForegroundView(geometry: geometry, name: "LOG IN")
                
                RectangleCustom(geometry: geometry)
                    .position(x: geometry.size.width / 2, y: geometry.size.height / 1.7)
                
                VStack {
                    Spacer()
                    
                    VStack(spacing: geometry.size.height * 0.025) {
                        Spacer()
                        
                        VStack(spacing: geometry.size.height * 0.005) {
                            Text("YOUR NICKNAME")
                                .Bowlby(size: 20)
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 255/255, green: 0/255, blue: 100/255),
                                                Color(red: 242/255, green: 2/255, blue: 253/255)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 5
                                    )
                                    .frame(width: geometry.size.width * 0.835, height: geometry.size.height * 0.1)
                                
                                TextField("", text: $nickname)
                                    .padding(.horizontal, geometry.size.width * 0.04)
                                    .frame(width: geometry.size.width * 0.835, height: geometry.size.height * 0.1)
                                    .background(Color(red: 47/255, green: 8/255, blue: 9/255))
                                    .cornerRadius(9)
                                    .foregroundColor(.white)
                                
                                if nickname.isEmpty {
                                    Text("WRITE YOUR NICKNAME HERE...")
                                        .font(.custom("BowlbyOneSC-Regular", size: 10))
                                        .foregroundColor(.white)
                                        .padding(.leading, geometry.size.width * 0.05)
                                }
                            }
                            .shadow(radius: 3, y: 4)
                        }
                        
                        VStack(spacing: geometry.size.height * 0.005) {
                            Text("PASSWROD")
                                .Bowlby(size: 20)
                            
                            ZStack(alignment: .leading) {
                                RoundedRectangle(cornerRadius: 9)
                                    .stroke(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color(red: 255/255, green: 0/255, blue: 100/255),
                                                Color(red: 242/255, green: 2/255, blue: 253/255)
                                            ]),
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        ),
                                        lineWidth: 5
                                    )
                                    .frame(width: geometry.size.width * 0.835, height: geometry.size.height * 0.1)
                                
                                SecureField("", text: $password)
                                    .padding(.horizontal, geometry.size.width * 0.04)
                                    .frame(width: geometry.size.width * 0.835, height: geometry.size.height * 0.1)
                                    .background(Color(red: 47/255, green: 8/255, blue: 9/255))
                                    .cornerRadius(9)
                                    .foregroundColor(.white)
                                
                                if password.isEmpty {
                                    Text("WRITE YOUR PASSWORD HERE...")
                                        .font(.custom("BowlbyOneSC-Regular", size: 10))
                                        .foregroundColor(.white)
                                        .padding(.leading, geometry.size.width * 0.05)
                                }
                            }
                            .shadow(radius: 3, y: 4)
                        }
                        
                        HStack(spacing: geometry.size.width * 0.061) {
                            Button(action: {
                                guard !nickname.isEmpty, !password.isEmpty else {
                                    alertMessage = "Nickname and password cannot be empty."
                                    showAlert = true
                                    return
                                }
                                
                                guard nickname.rangeOfCharacter(from: CharacterSet.alphanumerics) != nil,
                                      password.rangeOfCharacter(from: CharacterSet.alphanumerics) != nil else {
                                    alertMessage = "Nickname and password must contain at least one character."
                                    showAlert = true
                                    return
                                }
                                
                                service.loginUser(login: nickname, pass: password) { response in
                                    guard let response = response else {
                                        return
                                    }
                                    
                                    if response.status == "success" {
                                        DispatchQueue.main.async {
                                            self.sugarLoginModel.isMenu = true
                                            UserDefaultsManager().setLoginStatus(isLoggedIn: true)
                                            UserDefaultsManager().saveUserCredentials(login: nickname, password: password)
                                        }
                                    } else {
                                        DispatchQueue.main.async {
                                            alertMessage = response.message
                                            showAlert = true
                                        }
                                    }
                                }
                                
                               
                            }) {
                                ZStack {
                                    Image(.wideButtonBackground)
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.397, height: geometry.size.height * 0.1)
                                    
                                    Text("LOG IN")
                                        .Bowlby(size: 20)
                                }
                            }
                            .alert(isPresented: $showAlert) {
                                Alert(title: Text("Something went wrong"),
                                      message: Text(alertMessage),
                                      dismissButton: .default(Text("OK")))
                            }
                            
                            Button(action: {
                                presentationMode.wrappedValue.dismiss()
                            }) {
                                ZStack {
                                    Image(.wideButtonBackground)
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.397, height: geometry.size.height * 0.1)
                                    
                                    Text("GO BACK")
                                        .Bowlby(size: 20)
                                }
                            }
                        }
                        
                        VStack {
                            Text("OR")
                                .Bowlby(size: 20)
                            
                            HStack(spacing: geometry.size.width * 0.063) {
                                Button(action: {
                                    
                                }) {
                                    Image(.facebook)
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.157, height: geometry.size.width * 0.157)
                                }
                                .disabled(true)
                                
                                Button(action: {
                                    
                                }) {
                                    Image(.twiter)
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.157, height: geometry.size.width * 0.157)
                                }
                                .disabled(true)
                                
                                Button(action: {
                                    
                                }) {
                                    Image(.apple)
                                        .resizable()
                                        .frame(width: geometry.size.width * 0.157, height: geometry.size.width * 0.157)
                                }
                                .disabled(true)
                            }
                        }
                    }
                }
            }
            NavigationLink(destination: SugarMenuView(),
                           isActive: $sugarLoginModel.isMenu) {}
                .hidden()
        }
        .navigationBarBackButtonHidden(true)
    }
}


#Preview {
    SugarLoginView()
}


import SwiftUI

struct SettingsRectangle: View {
    var geometry: GeometryProxy
    var body: some View {
        Rectangle()
            .fill(Color(red: 109/255, green: 22/255, blue: 100/255))
            .frame(width: geometry.size.width * 0.863,
                   height: geometry.size.height * 0.3611)
            .opacity(0.9)
            .cornerRadius(10)
            .shadow(radius: 1, y: 7)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(LinearGradient(
                        gradient: Gradient(colors: [Color(red: 255/255, green: 0/255, blue: 100/255),
                                                    Color(red: 242/255, green: 2/255, blue: 253/255)]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ),
                            lineWidth: 5)
            )
    }
}

struct RectangleCustom: View {
    var geometry: GeometryProxy
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color(red: 109/255, green: 22/255, blue: 100/255))
                .opacity(0.9)
            
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: geometry.size.width, y: 0))
            }
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
        }
        .frame(width: geometry.size.width, height: geometry.size.height * 0.7)
        .offset(y: 90)
    }
}

struct SettingsVolume: View {
    var geometry: GeometryProxy
    var name: String
    var volumeIndex: Int
    var actionMinus: (() -> ())
    var actionPlus: (() -> ())
    var body: some View {
        VStack {
            Text(name)
                .Bowlby(size: 20)
            
            HStack {
                Button(action: {
                    actionMinus()
                }) {
                    Image(.minus)
                        .resizable()
                        .frame(width: geometry.size.width * 0.112,
                               height: geometry.size.width * 0.112)
                }
                .disabled(volumeIndex == 0 ? true : false)
                
                ForEach(0..<13) { index in
                    if volumeIndex <= index {
                        Rectangle()
                            .fill(.black)
                            .frame(width: geometry.size.width * 0.02,
                                   height: geometry.size.height * 0.0185)
                    } else {
                        Rectangle()
                            .fill(.white)
                            .frame(width: geometry.size.width * 0.02,
                                   height: geometry.size.height * 0.0185)
                    }
                }
                
                Button(action: {
                    actionPlus()
                }) {
                    Image(.plus)
                        .resizable()
                        .frame(width: geometry.size.width * 0.112,
                               height: geometry.size.width * 0.112)
                }
                .disabled(volumeIndex == 13 ? true : false)
            }
        }
    }
}

struct ForegroundViewMenu: View {
    var geometry: GeometryProxy
    var coin: String
    var firstLabel: String = "CANDY"
    var secondLabel: String = "RUSH"
    var body: some View {
        ZStack {
            Image(.menuForeground)
                .resizable()
                .frame(width: geometry.size.width * 0.825,
                       height: geometry.size.height * 0.467)
            
            VStack {
                VStack(spacing: -geometry.size.height * 0.027) {
                    Text(firstLabel)
                        .Bowlby(size: 50)
                    
                    Text(secondLabel)
                        .Bowlby(size: 50)
                }
                
                ZStack {
                    Image(.purpleLabelBackground)
                        .resizable()
                        .frame(width: geometry.size.width * 0.527,
                               height: geometry.size.height * 0.0715)
                    
                    HStack {
                        Text(coin)
                            .Bowlby(size: 20)
                        
                        Image(.candyForeground)
                            .resizable()
                            .frame(width: geometry.size.width * 0.092,
                                   height: geometry.size.width * 0.092)
                            .offset(y: -2)
                    }
                }
            }
               
        }
        .position(x: geometry.size.width / 2, y: geometry.size.height / 2.85)
    }
}

struct ShopButton: View {
    var geometry: GeometryProxy
    var body: some View {
        ZStack {
            Image(.wideButtonBackground)
                .resizable()
                .frame(width: geometry.size.width * 0.465,
                       height: geometry.size.height * 0.098)
            
            HStack(spacing: geometry.size.height * 0.0135) {
                Text("SHOP")
                    .Bowlby(size: 20, outlineWidth: 0.5)
                
                Image(.shopForeground)
                    .resizable()
                    .frame(width: geometry.size.width * 0.157,
                           height: geometry.size.height * 0.123)
                    .offset(y: -9)
            }
            .offset(x: 5)
        }
    }
}

struct RecordsButton: View {
    var geometry: GeometryProxy
    var body: some View {
        ZStack {
            Image(.wideButtonBackground)
                .resizable()
                .frame(width: geometry.size.width * 0.465,
                       height: geometry.size.height * 0.098)
            
            HStack(spacing: 5) {
                Image(.recordsForeground)
                    .resizable()
                    .frame(width: geometry.size.width * 0.199,
                           height: geometry.size.height * 0.1295)
                
                Text("records")
                    .Bowlby(size: 20, outlineWidth: 0.5)
            }
            .offset(x: -20)
        }
    }
}

struct PlayButton: View {
    var geometry: GeometryProxy
    var body: some View {
        ZStack {
            Image(.wideButtonBackground)
                .resizable()
                .frame(width: geometry.size.width * 0.605,
                       height: geometry.size.height * 0.127)
            
            HStack(spacing: geometry.size.height * 0.0135) {
                
                Image(.playForeground)
                    .resizable()
                    .frame(width: geometry.size.width * 0.205,
                           height: geometry.size.height * 0.119)
                
                
                Text("PLAY")
                    .Bowlby(size: 40)
            }
            .offset(x: -15, y: -2)
            
        }
    }
}

struct RecordForegroundView: View {
    var geometry: GeometryProxy
    var name: String
    var body: some View {
        Image(.menuForeground)
            .resizable()
            .frame(width: geometry.size.width * 0.825,
                   height: geometry.size.height * 0.467)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2.85)

        VStack(spacing: -20) {
            Text(name)
                .Bowlby(size: 50)
            
            Text("RECORDS")
                .Bowlby(size: 50)
                .lineSpacing(0)
        }
        .position(x: geometry.size.width / 2, y: geometry.size.height / 4.4)
    }
}

struct ForegroundView: View {
    var geometry: GeometryProxy
    var name: String
    var body: some View {
        Image(.menuForeground)
            .resizable()
            .frame(width: geometry.size.width * 0.825,
                   height: geometry.size.height * 0.467)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2.85)
        
        Text(name)
            .Bowlby(size: 50)
            .position(x: geometry.size.width / 2, y: geometry.size.height / 3.75)
    }
}

struct BackButton: View {
    var geometry: GeometryProxy
    var body: some View {
        HStack {
            VStack(spacing: 0) {
                ZStack {
                    Image(.squareButtonBackground)
                        .resizable()
                        .frame(width: geometry.size.width * 0.196,
                               height: geometry.size.height * 0.097)
                    
                    Image(.backArrow)
                        .resizable()
                        .frame(width: 35,
                               height: 19)
                }
                
                Text("back")
                    .Bowlby(size: 15, outlineWidth: 0.5)
            }
            .padding(.leading, 20)
            
            Spacer()
        }
    }
}

struct DoneButtonSettings: View {
    var geometry: GeometryProxy
    var action: (() -> ())
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Image(.squareButtonBackground)
                    .resizable()
                    .frame(width: geometry.size.width * 0.252,
                           height: geometry.size.height * 0.124)
                
                Image(.done)
                    .resizable()
                    .frame(width: geometry.size.width * 0.1225,
                           height: geometry.size.height * 0.062)
            }
        }
        .offset(y: -geometry.size.height * 0.053)
    }
}

struct LevelButton: View {
    var geometry: GeometryProxy
    var image: String
    var text: String
    var body: some View {
        ZStack {
            Image(image)
                .resizable()
                .frame(width: geometry.size.width * 0.197,
                       height: geometry.size.height * 0.097)
            
            Text(text)
                .Bowlby(size: 30)
        }
    }
}

struct SwitchButton: View {
    var image: String
    var geometry: GeometryProxy
    var action: (() -> ())
    var body: some View {
        Button(action: {
            action()
        }) {
            ZStack {
                Image(.squareButtonBackground)
                    .resizable()
                    .frame(width: geometry.size.width * 0.197,
                           height: geometry.size.height * 0.097)
                
                Image(image)
                    .resizable()
                    .frame(width: geometry.size.width * 0.072,
                           height: geometry.size.height * 0.052)
            }
        }
    }
}

struct RecordsView: View {
    var geometry: GeometryProxy
    var number: String
    var name: String
    var score: String
    var body: some View {
        HStack(spacing: 40) {
            ZStack {
                Rectangle()
                    .fill(Color(red: 109/255, green: 22/255, blue: 100/255))
                    .frame(width: geometry.size.width * 0.202,
                           height: geometry.size.height * 0.105)
                    .opacity(0.9)
                    .cornerRadius(5)
                    .shadow(radius: 1, y: 7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(LinearGradient(
                                gradient: Gradient(colors: [Color(red: 255/255, green: 0/255, blue: 100/255),
                                                            Color(red: 242/255, green: 2/255, blue: 253/255)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                                    lineWidth: 5)
                    )
                
                Text(number)
                    .Bowlby(size: 35)
            }
            
            ZStack {
                Rectangle()
                    .fill(Color(red: 109/255, green: 22/255, blue: 100/255))
                    .frame(width: geometry.size.width * 0.528,
                           height: geometry.size.height * 0.105)
                    .opacity(0.9)
                    .cornerRadius(5)
                    .shadow(radius: 1, y: 7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(LinearGradient(
                                gradient: Gradient(colors: [Color(red: 255/255, green: 0/255, blue: 100/255),
                                                            Color(red: 242/255, green: 2/255, blue: 253/255)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                                    lineWidth: 5)
                    )
                
                VStack(spacing: 5) {
                    Text(name)
                        .Bowlby(size: 15)
                        .frame(width: 165, height: 30)
                    
                    Text(score)
                        .Bowlby(size: 15)
                        .frame(width: 165, height: 30)
                }
            }
        }
    }
}

struct ShopForegroundView: View {
    var geometry: GeometryProxy
    var coin: String
    var body: some View {
        ZStack {
            Image(.menuForeground)
                .resizable()
                .frame(width: geometry.size.width * 0.825,
                       height: geometry.size.height * 0.467)
            
            VStack {
                Text("SHOP")
                    .Bowlby(size: 50)
                
                
                ZStack {
                    Image(.purpleLabelBackground)
                        .resizable()
                        .frame(width: geometry.size.width * 0.527,
                               height: geometry.size.height * 0.0715)
                    
                    HStack {
                        Text(coin)
                            .Bowlby(size: 20)
                        
                        Image(.candyForeground)
                            .resizable()
                            .frame(width: geometry.size.width * 0.092,
                                   height: geometry.size.width * 0.092)
                            .offset(y: -2)
                    }
                }
            }
            .position(x: geometry.size.width / 2, y: geometry.size.height / 2.35)
            
        }
        .position(x: geometry.size.width / 2, y: geometry.size.height / 3.2)
    }
}

struct ShopItem: View {
    var geometry: GeometryProxy
    var image: String
    var imageSizeW: CGFloat = 0.177
    var imageSizeH: CGFloat = 0.101
    var name: String
    var body: some View {
        ZStack {
            ZStack {
                Rectangle()
                    .fill(Color(red: 109/255, green: 22/255, blue: 100/255))
                    .frame(width: geometry.size.width * 0.605,
                           height: geometry.size.height * 0.254)
                    .opacity(0.9)
                    .cornerRadius(5)
                    .shadow(radius: 1, y: 7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(LinearGradient(
                                gradient: Gradient(colors: [Color(red: 255/255, green: 0/255, blue: 100/255),
                                                            Color(red: 242/255, green: 2/255, blue: 253/255)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                                    lineWidth: 5)
                    )
                
                VStack {
                    HStack(spacing: geometry.size.width * 0.077) {
                        Image(image)
                            .resizable()
                            .frame(width: geometry.size.width * imageSizeW,
                                   height: geometry.size.height * imageSizeH)
                        
                        Text("X 1")
                            .Bowlby(size: 25)
                    }
                    
                    HStack {
                        Text("COST:30")
                            .Bowlby(size: 15)
                        
                        Image(.candyForeground)
                            .resizable()
                            .frame(width: geometry.size.width * 0.072,
                                   height: geometry.size.width * 0.072)
                            .offset(y: -4)
                    }
                }
                .offset(y: 15)
            }
            ZStack {
                Rectangle()
                    .fill(Color(red: 109/255, green: 22/255, blue: 100/255))
                    .frame(width: geometry.size.width * 0.605,
                           height: geometry.size.height * 0.073)
                    .opacity(0.9)
                    .cornerRadius(5)
                    .shadow(radius: 1, y: 7)
                    .overlay(
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(LinearGradient(
                                gradient: Gradient(colors: [Color(red: 255/255, green: 0/255, blue: 100/255),
                                                            Color(red: 242/255, green: 2/255, blue: 253/255)]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ),
                                    lineWidth: 5)
                    )
                
                Text(name)
                    .Bowlby(size: 15)
            }
                .offset(y: -geometry.size.height * 0.113)
        }
    }
}

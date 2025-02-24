import SwiftUI

struct SugarMyRecordsView: View {
    @StateObject var sugarMyRecordsModel =  SugarMyRecordsViewModel()
    let service = APIManager()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.mainBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                RecordForegroundView(geometry: geometry, name: "MY")
                
                VStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        BackButton(geometry: geometry)
                    }
                    
                    Spacer()
                    
                    VStack {
                        ForEach((sugarMyRecordsModel.indexInCycle)..<(sugarMyRecordsModel.indexInCycle + 4), id: \.self) { index in
                            if index < sugarMyRecordsModel.records.count {
                                RecordsView(geometry: geometry, number: "\(index + 1)", name: sugarMyRecordsModel.username, score: "\(sugarMyRecordsModel.records[index])")
                            } else {
                                RecordsView(geometry: geometry, number: "\(index + 1)", name: sugarMyRecordsModel.username, score: "No records yet")
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.bottom, 30)
                    
                    
                    HStack(spacing: 35) {
                        VStack {
                            SwitchButton(image: SugarImageName.backArrow2.rawValue,
                                         geometry: geometry) {
                                sugarMyRecordsModel.lowerIndex()
                            }
                                         .disabled(sugarMyRecordsModel.currentIndex == 0 ? true : false)
                        }
                        
                        Text("\(sugarMyRecordsModel.currentIndex + 1)\\3")
                            .Bowlby(size: 35)
                        
                        VStack {
                            SwitchButton(image: SugarImageName.nextArrow.rawValue,
                                         geometry: geometry) {
                                sugarMyRecordsModel.increaseIndex()
                            }
                                         .disabled(sugarMyRecordsModel.currentIndex == 2 ? true : false)
                        }
                    }
                }
            }
            .onAppear {
                sugarMyRecordsModel.loadRecords()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SugarMyRecordsView()
}


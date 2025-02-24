import SwiftUI

struct SugarWorldRecordsView: View {
    @StateObject var sugarWorldRecordsModel =  SugarWorldRecordsViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.mainBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                RecordForegroundView(geometry: geometry, name: "WORLD")
                
                VStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        BackButton(geometry: geometry)
                    }
                    
                    Spacer()
                    
                    VStack {
                        ForEach((sugarWorldRecordsModel.indexInCycle)..<(sugarWorldRecordsModel.indexInCycle + 4), id: \.self) { index in
                            if index < sugarWorldRecordsModel.records.count {
                                RecordsView(geometry: geometry, number: "\(index + 1)", name: sugarWorldRecordsModel.records[index].login, score: "score \(sugarWorldRecordsModel.records[index].record)")
                            } else {
                                RecordsView(geometry: geometry, number: "\(index + 1)", name: "player", score: "Пока нет рекордов")
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.bottom, 30)
                    
                    
                    HStack(spacing: 35) {
                        VStack {
                            SwitchButton(image: SugarImageName.backArrow2.rawValue,
                                         geometry: geometry) {
                                DispatchQueue.main.async {
                                    sugarWorldRecordsModel.lowerIndex()
                                }
                            }
                                         .disabled(sugarWorldRecordsModel.currentIndex == 0 ? true : false)
                        }
                        
                        Text("\(sugarWorldRecordsModel.currentIndex + 1)\\3")
                            .Bowlby(size: 35)
                        
                        VStack {
                            SwitchButton(image: SugarImageName.nextArrow.rawValue,
                                         geometry: geometry) {
                                DispatchQueue.main.async {
                                    sugarWorldRecordsModel.increaseIndex()
                                }
                            }
                                         .disabled(sugarWorldRecordsModel.currentIndex == 2 ? true : false)
                        }
                    }
                }
            }
            .onAppear() {
                sugarWorldRecordsModel.loadAllRecords()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SugarWorldRecordsView()
}


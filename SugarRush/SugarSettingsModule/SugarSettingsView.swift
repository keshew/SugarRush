import SwiftUI

struct SugarSettingsView: View {
    @StateObject var sugarSettingsModel =  SugarSettingsViewModel()
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var audioManager = AudioManager.shared
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.mainBackground)
                    .resizable()
                    .ignoresSafeArea()
                
                ForegroundView(geometry: geometry, name: "settings")
                
                VStack {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        BackButton(geometry: geometry)
                    }
                    
                    Spacer()
                    
                    VStack {
                        ZStack {
                            SettingsRectangle(geometry: geometry)
                            
                            VStack {
                                SettingsVolume(geometry: geometry,
                                               name: "MUSIC",
                                               volumeIndex: sugarSettingsModel.musicIndexCount) {
                                    sugarSettingsModel.lowerMusic()
                                } actionPlus: {
                                    sugarSettingsModel.increaseMusic()
                                }
                                
                                SettingsVolume(geometry: geometry,
                                               name: "SOUND",
                                               volumeIndex: sugarSettingsModel.soundIndexCount) {
                                    sugarSettingsModel.lowerSound()
                                } actionPlus: {
                                    sugarSettingsModel.increaseSound()
                                }
                            }
                            .offset(y: -geometry.size.height * 0.014)
                        }
                        
                        DoneButtonSettings(geometry: geometry) {
                            UserDefaultsManager().saveVolumeSettings(backgroundVolume: audioManager.backgroundVolume,
                                                                          soundEffectVolume: audioManager.soundEffectVolume)
                        }
                    }
                    .padding(.bottom, geometry.size.height * 0.0799)
                }
            }
            .onAppear {
                let (backgroundVolume, soundEffectVolume) = UserDefaultsManager().loadVolumeSettings()
                audioManager.backgroundVolume = backgroundVolume
                audioManager.soundEffectVolume = soundEffectVolume
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

#Preview {
    SugarSettingsView()
}


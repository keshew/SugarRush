import SwiftUI

class SugarSettingsViewModel: ObservableObject {
    let contact = SugarSettingsModel()
    @Published var soundIndexCount: Int {
           didSet {
               if soundIndexCount < 0 {
                   soundIndexCount = 0
               } else if soundIndexCount > 13 {
                   soundIndexCount = 13
               }
           }
       }
       @Published var musicIndexCount: Int {
           didSet {
               if musicIndexCount < 0 {
                   musicIndexCount = 0
               } else if musicIndexCount > 13 {
                   musicIndexCount = 13
               }
           }
       }
    
    init() {
        soundIndexCount = Int(audioManager.soundEffectVolume * 13)
        musicIndexCount = Int(audioManager.backgroundVolume * 13)
    }
    
    let audioManager = AudioManager.shared
    
    func increaseSound() {
        if soundIndexCount < 13 {
            soundIndexCount += 1
            audioManager.soundEffectVolume = Float(soundIndexCount) / 13.0
        }
    }
    
    func lowerSound() {
        if soundIndexCount > 0 {
            soundIndexCount -= 1
            audioManager.soundEffectVolume = Float(soundIndexCount) / 13.0
        }
    }
    
    func increaseMusic() {
        if musicIndexCount < 13 {
            musicIndexCount += 1
            audioManager.backgroundVolume = Float(musicIndexCount) / 13.0
        }
    }
    
    func lowerMusic() {
        if musicIndexCount > 0 {
            musicIndexCount -= 1
            audioManager.backgroundVolume = Float(musicIndexCount) / 13.0
        }
    }
}


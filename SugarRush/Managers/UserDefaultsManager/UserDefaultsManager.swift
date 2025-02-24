import SwiftUI

enum Keys: String {
    case currentLevel = "currentLevel"
    case money = "money"
    case backgroundVolume = "backgroundVolume"
    case soundEffectVolume = "soundEffectVolume"
    case timeCount = "timeCount"
    case hummerCount = "hummerCount"
    case isLoggedIn = "isLoggedIn"
    case userLogin = "userLogin"
    case userPassword = "userPassword"
}

class UserDefaultsManager: ObservableObject {
    static let defaults = UserDefaults.standard
    
    func firstLaunch() {
        if UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) == nil {
            UserDefaultsManager.defaults.set(1, forKey: Keys.currentLevel.rawValue)
            UserDefaultsManager.defaults.set(2, forKey: Keys.timeCount.rawValue)
            UserDefaultsManager.defaults.set(2, forKey: Keys.hummerCount.rawValue)
            UserDefaultsManager.defaults.set(1000, forKey: Keys.money.rawValue)
            UserDefaultsManager.defaults.set(0.5, forKey: Keys.backgroundVolume.rawValue)
            UserDefaultsManager.defaults.set(0.5, forKey: Keys.soundEffectVolume.rawValue)
            UserDefaultsManager.defaults.set(false, forKey: Keys.isLoggedIn.rawValue)
        }
    }
    
    func saveUserCredentials(login: String, password: String) {
        UserDefaultsManager.defaults.set(login, forKey: Keys.userLogin.rawValue)
        UserDefaultsManager.defaults.set(password, forKey: Keys.userPassword.rawValue)
    }
    
    func getUserCredentials() -> (login: String?, password: String?) {
        let login = UserDefaultsManager.defaults.string(forKey: Keys.userLogin.rawValue)
        let password = UserDefaultsManager.defaults.string(forKey: Keys.userPassword.rawValue)
        return (login, password)
    }
    
    func setLoginStatus(isLoggedIn: Bool) {
        UserDefaultsManager.defaults.set(isLoggedIn, forKey: Keys.isLoggedIn.rawValue)
    }
    
    func getLoginStatus() -> Bool {
        return UserDefaultsManager.defaults.bool(forKey: Keys.isLoggedIn.rawValue)
    }
    
    func useBonus(key: String) {
        let hummer = UserDefaultsManager.defaults.integer(forKey: key)
        if hummer > 0 {
            UserDefaultsManager.defaults.set(hummer - 1, forKey: key)
        }
    }
    
    func buyBonus(key: String) {
        let money = UserDefaultsManager.defaults.integer(forKey: Keys.money.rawValue)
        let bonus = UserDefaultsManager.defaults.integer(forKey: key)
        if money >= 30 {
            UserDefaultsManager.defaults.set(bonus + 1, forKey: key)
            UserDefaultsManager.defaults.set(money - 30, forKey: Keys.money.rawValue)
        }
    }
    
    func completeLevel() {
        let money = UserDefaultsManager.defaults.integer(forKey: Keys.money.rawValue)
        let currentLevel = UserDefaultsManager.defaults.integer(forKey: Keys.currentLevel.rawValue)
        
        if currentLevel <= 12 {
            UserDefaultsManager.defaults.set(currentLevel + 1, forKey: Keys.currentLevel.rawValue)
            UserDefaultsManager.defaults.set(money + 30, forKey: Keys.money.rawValue)
        }
    }
    
    
    func saveVolumeSettings(backgroundVolume: Float, soundEffectVolume: Float) {
        UserDefaultsManager.defaults.set(backgroundVolume, forKey: Keys.backgroundVolume.rawValue)
        UserDefaultsManager.defaults.set(soundEffectVolume, forKey: Keys.soundEffectVolume.rawValue)
    }
    
    func loadVolumeSettings() -> (Float, Float) {
        var backgroundVolume = UserDefaultsManager.defaults.float(forKey: Keys.backgroundVolume.rawValue)
        var soundEffectVolume = UserDefaultsManager.defaults.float(forKey: Keys.soundEffectVolume.rawValue)
        if backgroundVolume == 0.0 && soundEffectVolume == 0.0 {
            backgroundVolume = 0.5
            soundEffectVolume = 0.5
        }
        return (backgroundVolume, soundEffectVolume)
    }
}


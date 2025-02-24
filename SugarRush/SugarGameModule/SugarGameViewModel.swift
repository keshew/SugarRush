import SwiftUI

class SugarGameViewModel: ObservableObject {
    let contact = SugarGameModel()

    func createSugarGameScene(gameData: SugarGameData, level: Int) -> SugarGameSpriteKit {
        let scene = SugarGameSpriteKit(level: level)
        scene.game  = gameData
        return scene
    }
}

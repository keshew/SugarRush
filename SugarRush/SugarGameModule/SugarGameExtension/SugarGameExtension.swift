import SwiftUI
import SpriteKit

extension SugarGameSpriteKit {

    func createTappedView() {
        //MARK: - pause
        let pauseBackground = SKSpriteNode(imageNamed: SugarImageName.squareButtonBackground.rawValue)
        pauseBackground.size = CGSize(width: size.width * 0.18575, height: size.height * 0.09037)
        pauseBackground.name = "pauseBackground"
        pauseBackground.position = CGPoint(x: size.width / 6, y: size.height / 1.13)
        addChild(pauseBackground)

        let pause = SKSpriteNode(imageNamed: SugarImageName.backArrow.rawValue)
        pause.name = "pause"
        pause.size = CGSize(width: size.width * 0.08906, height: size.height * 0.02230)
        pause.position = CGPoint(x: size.width / 6, y: size.height / 1.13)
        addChild(pause)

        let pauseLabel = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        pauseLabel.attributedText = NSAttributedString(string: "pause", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: size.width * 0.03817)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -6
        ])
        pauseLabel.position = CGPoint(x: size.width / 6, y: size.height / 1.235)
        addChild(pauseLabel)

        //MARK: - rules
        let rulesBackground = SKSpriteNode(imageNamed: SugarImageName.squareButtonBackground.rawValue)
        rulesBackground.name = "rulesBackground"
        rulesBackground.size = CGSize(width: size.width * 0.18575, height: size.height * 0.09037)
        rulesBackground.position = CGPoint(x: size.width / 1.2, y: size.height / 1.13)
        addChild(rulesBackground)

        let rules = SKSpriteNode(imageNamed: SugarImageName.backArrow.rawValue)
        rules.name = "rules"
        rules.size = CGSize(width: size.width * 0.08906, height: size.height * 0.02230)
        rules.position = CGPoint(x: size.width / 1.2, y: size.height / 1.13)
        addChild(rules)

        let rulesLabel = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        rulesLabel.attributedText = NSAttributedString(string: "rules", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: size.width * 0.03817)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -6
        ])
        rulesLabel.position = CGPoint(x: size.width / 1.2, y: size.height / 1.235)
        addChild(rulesLabel)

        //MARK: - hummerTool
        let hammerBackground = SKSpriteNode(imageNamed: SugarImageName.squareButtonBackground.rawValue)
        hammerBackground.name = "hammerBackground"
        hammerBackground.size = CGSize(width: size.width * 0.18575, height: size.height * 0.09037)
        hammerBackground.position = CGPoint(x: size.width / 6, y: size.height / 9)
        addChild(hammerBackground)

        hammer = SKSpriteNode(imageNamed: SugarImageName.hummer.rawValue)
        hammer.name = "hammer"
        hammer.size = CGSize(width: size.width * 0.07124, height: size.height * 0.03638)
        hammer.position = CGPoint(x: size.width / 6, y: size.height / 9)
        addChild(hammer)

        let hummerLabel = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        hummerLabel.attributedText = NSAttributedString(string: "BLOCK", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: size.width * 0.03817)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -6
        ])
        hummerLabel.position = CGPoint(x: size.width / 6, y: size.height / 25)
        addChild(hummerLabel)

        let hummerLabel2 = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        hummerLabel2.attributedText = NSAttributedString(string: "BREAKER", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: size.width * 0.03817)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -6
        ])
        hummerLabel2.position = CGPoint(x: size.width / 6, y: size.height / 50)
        addChild(hummerLabel2)

        let hummerCountBack = SKSpriteNode(imageNamed: SugarImageName.countBonusBackground.rawValue)
        hummerCountBack.name = "hummerCountBack"
        hummerCountBack.size = CGSize(width: size.width * 0.07888, height: size.height * 0.03286)
        hummerCountBack.position = CGPoint(x: size.width / 4.7, y: size.height / 12)
        addChild(hummerCountBack)

        hummerCountLabel = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        hummerCountLabel.attributedText = NSAttributedString(string: "\(UserDefaultsManager.defaults.integer(forKey: Keys.hummerCount.rawValue))", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: size.width * 0.03817)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -6
        ])
        hummerCountLabel.position = CGPoint(x: size.width / 4.73, y: size.height / 14.3)
        addChild(hummerCountLabel)

        //MARK: - time tool
        let timeBonusBackground = SKSpriteNode(imageNamed: SugarImageName.squareButtonBackground.rawValue)
        timeBonusBackground.name = "timeBonusBackground"
        timeBonusBackground.size = CGSize(width: size.width * 0.18575, height: size.height * 0.09037)
        timeBonusBackground.position = CGPoint(x: size.width / 1.2, y: size.height / 9)
        addChild(timeBonusBackground)

        let timeBonus = SKSpriteNode(imageNamed: SugarImageName.time.rawValue)
        timeBonus.name = "timeBonus"
        timeBonus.size = CGSize(width: size.width * 0.08651, height: size.height * 0.03991)
        timeBonus.position = CGPoint(x: size.width / 1.2, y: size.height / 9)
        addChild(timeBonus)

        let timeCountBack = SKSpriteNode(imageNamed: SugarImageName.countBonusBackground.rawValue)
        timeCountBack.name = "timeCountBack"
        timeCountBack.size = CGSize(width: size.width * 0.07888, height: size.height * 0.03286)
        timeCountBack.position = CGPoint(x: size.width / 1.32, y: size.height / 12)
        addChild(timeCountBack)

        timeCountLabel = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        timeCountLabel.attributedText = NSAttributedString(string: "\(UserDefaultsManager.defaults.integer(forKey: Keys.timeCount.rawValue))", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: size.width * 0.03817)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -6
        ])
        timeCountLabel.position = CGPoint(x: size.width / 1.325, y: size.height / 14.3)
        addChild(timeCountLabel)

        let timeBonusLabel = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        timeBonusLabel.attributedText = NSAttributedString(string: "BONUS", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: size.width * 0.03817)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -6
        ])
        timeBonusLabel.position = CGPoint(x: size.width / 1.2, y: size.height / 25)
        addChild(timeBonusLabel)

        let timeBonusLabel2 = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        timeBonusLabel2.attributedText = NSAttributedString(string: "TIME", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: size.width * 0.03817)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -6
        ])
        timeBonusLabel2.position = CGPoint(x: size.width / 1.2, y: size.height / 50)
        addChild(timeBonusLabel2)
    }

    func createMainView() {
        let gameBackground = SKSpriteNode(imageNamed: SugarImageName.gameBackground.rawValue)
        gameBackground.size = CGSize(width: size.width, height: size.height)
        gameBackground.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(gameBackground)

        let mainRectangle = SKShapeNode(rectOf: CGSize(width: size.width * 0.94147, height: size.height * 0.42840), cornerRadius: 5)
        mainRectangle.fillColor = UIColor(red: 109/255, green: 22/255, blue: 100/255, alpha: 0.9)
        mainRectangle.strokeColor = UIColor(red: 255/255, green: 0/255, blue: 100/255, alpha: 1)
        mainRectangle.lineWidth = 5
        mainRectangle.position = CGPoint(x: size.width / 2, y: size.height / 2.05)
        addChild(mainRectangle)

        let timeLabel = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        timeLabel.attributedText = NSAttributedString(string: "TIME:", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: size.width * 0.03817)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -8
        ])
        timeLabel.position = CGPoint(x: size.width / 2, y: size.height / 4.45)
        addChild(timeLabel)

        let loadingBack = SKShapeNode(rectOf: CGSize(width: size.width * 0.79644, height: size.height * 0.02465), cornerRadius: 10)
        loadingBack.fillColor = UIColor.black
        loadingBack.strokeColor = .clear
        loadingBack.lineWidth = 5
        loadingBack.position = CGPoint(x: size.width / 2, y: size.height / 4.85)
        addChild(loadingBack)

        let coinRectangle = SKShapeNode(rectOf: CGSize(width: size.width * 0.41730, height: size.height * 0.04108), cornerRadius: 5)
        coinRectangle.fillColor = UIColor(red: 109/255, green: 22/255, blue: 100/255, alpha: 0.9)
        coinRectangle.strokeColor = UIColor(red: 255/255, green: 0/255, blue: 100/255, alpha: 1)
        coinRectangle.lineWidth = 5
        coinRectangle.position = CGPoint(x: size.width / 4.2, y: size.height / 1.35)
        addChild(coinRectangle)

        let coinLabel = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        coinLabel.attributedText = NSAttributedString(string: "COIN:\(UserDefaultsManager.defaults.integer(forKey: Keys.money.rawValue))", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: size.width * 0.03053)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -4
        ])
        coinLabel.position = CGPoint(x: size.width / 5.1, y: size.height / 1.368)
        addChild(coinLabel)

        let candy = SKSpriteNode(imageNamed: SugarImageName.candyForeground.rawValue)
        candy.size = CGSize(width: size.width * 0.06361, height: size.height * 0.02934)
        candy.position = CGPoint(x: size.width / 2.6, y: size.height / 1.35)
        addChild(candy)

        let scoreRectangle = SKShapeNode(rectOf: CGSize(width: size.width * 0.41730, height: size.height * 0.04108), cornerRadius: 5)
        scoreRectangle.fillColor = UIColor(red: 109/255, green: 22/255, blue: 100/255, alpha: 0.9)
        scoreRectangle.strokeColor = UIColor(red: 255/255, green: 0/255, blue: 100/255, alpha: 1)
        scoreRectangle.lineWidth = 5
        scoreRectangle.position = CGPoint(x: size.width / 1.32, y: size.height / 1.35)
        addChild(scoreRectangle)

        scoreLabel = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        scoreLabel.attributedText = NSAttributedString(string: "SCORE: \(game?.score ?? 0)", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: size.width * 0.03053)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -4
        ])
        scoreLabel.position = CGPoint(x: size.width / 1.39, y: size.height / 1.368)
        addChild(scoreLabel)

        let prize = SKSpriteNode(imageNamed: SugarImageName.recordsForegroundImage.rawValue)
        prize.size = CGSize(width: size.width * 0.06869, height: size.height * 0.03873)
        prize.position = CGPoint(x: size.width / 1.1, y: size.height / 1.35)
        addChild(prize)

        let lines = SKSpriteNode(imageNamed: SugarImageName.lines.rawValue)
        lines.size = CGSize(width: size.width * 0.52163, height: size.height * 0.22300)
        lines.position = mainRectangle.position
        addChild(lines)
    }

    func createMutatingView() {
        let levelLabel = SKLabelNode(fontNamed: "BowlbyOneSC-Regular")
        levelLabel.attributedText = NSAttributedString(string: "LEVEL \(level)", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: size.width * 0.07634)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -6
        ])
        levelLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.26)
        addChild(levelLabel)
    }
}


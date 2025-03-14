import SwiftUI
import SpriteKit

class SugarGameData: ObservableObject {
    @Published var isPause = false
    @Published var isMenu = false
    @Published var isWin = false
    @Published var isLose = false
    @Published var isRules = false
    @Published var isHummerTapped = false
    @Published var score = 0
    @Published var scene = SKScene()
}

class SugarGameSpriteKit: SKScene, SKPhysicsContactDelegate {
    var game: SugarGameData?
    var blocksOutsideGrid: [SKSpriteNode] = []
    var blockInsideGrid: [SKSpriteNode] = []
    var blockMapping: [SKSpriteNode: SKSpriteNode] = [:]
    let moveDuration: TimeInterval = 0.5
    var scoreLabel: SKLabelNode!
    var loadingLine: SKShapeNode!
    var currentWidth: CGFloat = 30
    var previousWidth: CGFloat = 30
    let level: Int
    var hammer: SKSpriteNode!
    var hummerCountLabel: SKLabelNode!
    var timeCountLabel: SKLabelNode!
    
    init(level: Int) {
        self.level = level
        super.init(size: UIScreen.main.bounds.size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func tapOnPause(touchLocation: CGPoint) {
        if let tappedNode = self.atPoint(touchLocation) as? SKSpriteNode,
           tappedNode.name == "pauseBackground" || tappedNode.name == "pause" {
            game!.isPause = true
            game!.scene = scene!
            scene?.isPaused = true
        }
    }
    
    func tapOnRules(touchLocation: CGPoint) {
        if let tappedNode = self.atPoint(touchLocation) as? SKSpriteNode,
           tappedNode.name == "rulesBackground" || tappedNode.name == "rules" {
            game!.isRules = true
            game!.scene = scene!
            scene?.isPaused = true
        }
    }
    
    func tapOnHummmer(touchLocation: CGPoint) {
        if let tappedNode = self.atPoint(touchLocation) as? SKSpriteNode,
           tappedNode.name == "hammerBackground" || tappedNode.name == "hammer" || tappedNode.name == "hummerCountBack" {
            guard UserDefaultsManager.defaults.object(forKey: Keys.hummerCount.rawValue) as? Int ?? 0 != 0 else { return }
            game!.isHummerTapped.toggle()
            if game!.isHummerTapped {
                hammer.setScale(1.5)
            } else {
                hammer.setScale(1)
            }
        } else if game!.isHummerTapped {
            if let blockNode = self.atPoint(touchLocation) as? SKSpriteNode,
                blockInsideGrid.contains(blockNode) {
                removeBlock(blockNode)
            }
        }
    }
    
    func removeBlock(_ block: SKSpriteNode) {
        guard UserDefaultsManager.defaults.object(forKey: Keys.hummerCount.rawValue) as? Int ?? 0 != 0 else { return }
        
        game!.isHummerTapped = false
        UserDefaultsManager().useBonus(key: Keys.hummerCount.rawValue)
        hammer.setScale(1)
        
        guard blockInsideGrid.contains(block) else {
            return
        }
        
        let fadeOut = SKAction.fadeOut(withDuration: 0.3)
        let remove = SKAction.removeFromParent()
        let sequence = SKAction.sequence([fadeOut, remove])
        
        hummerCountLabel.attributedText = NSAttributedString(string: "\(UserDefaultsManager.defaults.integer(forKey: Keys.hummerCount.rawValue))", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: 15)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -6
        ])
        
        game!.score += 50
        scoreLabel.attributedText = NSAttributedString(string: "SCORE: \(game?.score ?? 0)", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: 12)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -4
        ])
        
        block.run(sequence) {
            self.blockInsideGrid.removeAll(where: { $0 == block })
            self.assignClosestBlocks()
            
            if self.checkIfGridIsEmpty() {
                self.game!.isWin = true
            }
        }
    }
    
    func tapOnTime(touchLocation: CGPoint) {
        if let tappedNode = self.atPoint(touchLocation) as? SKSpriteNode, tappedNode.name == "timeBonusBackground" || tappedNode.name == "timeBonus" || tappedNode.name == "timeCountBack" {
            guard UserDefaultsManager.defaults.object(forKey: Keys.timeCount.rawValue) as? Int ?? 0 != 0 else { return }
            
            if level <= 4, currentWidth >= size.width * 0.173 {
                currentWidth -= size.width * 0.171
                
                let waitAction = SKAction.wait(forDuration: 0.5)
                let deltaWidth = self.currentWidth - self.previousWidth
                let moveAction = SKAction.move(to: CGPoint(x: self.loadingLine.position.x + deltaWidth / 2, y: self.loadingLine.position.y), duration: 0.5)
                
                let sequenceAction = SKAction.sequence([waitAction, moveAction])
                self.loadingLine.run(sequenceAction)
            } else if level >= 5, level <= 8, currentWidth >= size.width * 0.234 {
                currentWidth -= size.width * 0.229
                
                let waitAction = SKAction.wait(forDuration: 0.5)
                let deltaWidth = self.currentWidth - self.previousWidth
                let moveAction = SKAction.move(to: CGPoint(x: self.loadingLine.position.x + deltaWidth / 2, y: self.loadingLine.position.y), duration: 0.5)
                
                let sequenceAction = SKAction.sequence([waitAction, moveAction])
                self.loadingLine.run(sequenceAction)
            } else if level >= 8, level <= 12, currentWidth >= size.width * 0.343 {
                currentWidth -= size.width * 0.343
                
                let waitAction = SKAction.wait(forDuration: 0.5)
                let deltaWidth = self.currentWidth - self.previousWidth
                let moveAction = SKAction.move(to: CGPoint(x: self.loadingLine.position.x + deltaWidth / 2, y: self.loadingLine.position.y), duration: 0.5)
                
                let sequenceAction = SKAction.sequence([waitAction, moveAction])
                self.loadingLine.run(sequenceAction)
            }
            
            timeCountLabel.attributedText = NSAttributedString(string: "\(UserDefaultsManager.defaults.integer(forKey: Keys.timeCount.rawValue))", attributes: [
                NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: 15)!,
                NSAttributedString.Key.foregroundColor: UIColor.white,
                NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
                NSAttributedString.Key.strokeWidth: -6
            ])
            
            UserDefaultsManager().useBonus(key: Keys.timeCount.rawValue)
        }
    }
    
    func createVerticalBlock(with: String, positionX: CGFloat) {
        if size.width > 1000 {
            for row in 0..<8 {
                for column in 0..<3 {
                    let sprite = SKSpriteNode(imageNamed: with)
                    sprite.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                    sprite.name = with
                    sprite.position = CGPoint(x: size.width / positionX + CGFloat(column) * size.width * 0.06,
                                              y: size.height / 2.565 + CGFloat(row) * size.width * 0.037)
                    addChild(sprite)
                    blocksOutsideGrid.append(sprite)
                }
            }
        } else if size.width > 450 {
            for row in 0..<8 {
                for column in 0..<3 {
                    let sprite = SKSpriteNode(imageNamed: with)
                    sprite.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                    sprite.name = with
                    sprite.position = CGPoint(x: size.width / positionX + CGFloat(column) * size.width * 0.06,
                                              y: size.height / 2.565 + CGFloat(row) * size.width * 0.04)
                    addChild(sprite)
                    blocksOutsideGrid.append(sprite)
                }
            }
        } else {
            for row in 0..<8 {
                for column in 0..<3 {
                    let sprite = SKSpriteNode(imageNamed: with)
                    sprite.size = CGSize(width: 22, height: 22)
                    sprite.name = with
                    sprite.position = CGPoint(x: size.width / positionX + CGFloat(column) * 23.5,
                                              y: size.height / 2.565 + CGFloat(row) * 23.5)
                    addChild(sprite)
                    blocksOutsideGrid.append(sprite)
                }
            }
        }
    }
    
    func createHorizontalBlock(with: String, positionY: CGFloat) {
        if size.width > 450 {
            for row in 0..<3 {
                for column in 0..<8 {
                    let sprite = SKSpriteNode(imageNamed: with)
                    sprite.size = CGSize(width: size.width * 0.061, height: size.width * 0.037)
                    sprite.name = with
                    sprite.position = CGPoint(x: size.width / 3.65 + CGFloat(column) * size.width * 0.0643,
                                              y: size.height / positionY + CGFloat(row) * size.width * 0.037)
                    addChild(sprite)
                    blocksOutsideGrid.append(sprite)
                }
            }
        } else {
            for row in 0..<3 {
                for column in 0..<8 {
                    let sprite = SKSpriteNode(imageNamed: with)
                    sprite.size = CGSize(width: 23, height: 21)
                    sprite.name = with
                    sprite.position = CGPoint(x: size.width / 3.65 + CGFloat(column) * 25.5,
                                              y: size.height / positionY + CGFloat(row) * 23.5)
                    addChild(sprite)
                    blocksOutsideGrid.append(sprite)
                }
            }
        }
    }
    
    func findBlocksInSameRow(as blockInsideGrid: SKSpriteNode?) -> [SKSpriteNode] {
        guard let block = blockInsideGrid else { return [] }
        let targetY = block.position.y
        return self.blockInsideGrid.filter { abs($0.position.y - targetY) < 5 }
    }
    
    func findVerticalBlocksInSameRow(as blockInsideGrid: SKSpriteNode?) -> [SKSpriteNode] {
        guard let block = blockInsideGrid else { return [] }
        let targetX = block.position.x
        return self.blockInsideGrid.filter { abs($0.position.x - targetX) < 5 }
    }
    
    func setupView() {
        createMainView()
        createTappedView()
        createMutatingView()
        if size.width > 450 {
            createVerticalBlock(with: SugarImageName.blockToRight.rawValue, positionX: 13)
            createVerticalBlock(with: SugarImageName.blockToLeft.rawValue, positionX: 1.25)
            createHorizontalBlock(with: SugarImageName.blockToTop.rawValue, positionY: 3.3)
            createHorizontalBlock(with: SugarImageName.blockToBottom.rawValue, positionY: 1.62)
        } else {
            createVerticalBlock(with: SugarImageName.blockToRight.rawValue, positionX: 12)
            createVerticalBlock(with: SugarImageName.blockToLeft.rawValue, positionX: 1.25)
            createHorizontalBlock(with: SugarImageName.blockToTop.rawValue, positionY: 3.3)
            createHorizontalBlock(with: SugarImageName.blockToBottom.rawValue, positionY: 1.62)
        }
        if size.width > 450 {
            createRandomBlockWidth()
        } else {
            createRandomBlock()
        }
        
        assignClosestBlocks()
        
        loadingLine = SKShapeNode(rectOf: CGSize(width: currentWidth, height: 15), cornerRadius: 8)
        loadingLine.fillColor = UIColor(red: 255/255, green: 0/255, blue: 222/255, alpha: 1)
        loadingLine.strokeColor = .clear
        loadingLine.lineWidth = 5
        let startX = size.width / 6.3 - currentWidth / 2
        loadingLine.position = CGPoint(x: startX + currentWidth / 2, y: size.height / 4.85)
        
        addChild(loadingLine)
    }
    
    @objc func timerAction() {
        if !(game?.isRules ?? false) && !(game?.isPause ?? false) && !(game?.isWin ?? false) && !(game?.isLose ?? false) {
            updateLoadingLine()
        }
    }
    
    func updateLoadingLine() {
        let maxWidth: CGFloat = 300
        previousWidth = currentWidth
        
        if level <= 4 {
            currentWidth = min(currentWidth + 2.25, maxWidth)
        } else if level >= 5, level <= 8 {
            currentWidth = min(currentWidth + 3, maxWidth)
        } else if level >= 8, level <= 12 {
            currentWidth = min(currentWidth + 4.5, maxWidth)
        }
        
        let deltaWidth = currentWidth - previousWidth
        loadingLine.position.x += deltaWidth / 2
        loadingLine.path = CGPath(roundedRect: CGRect(x: -currentWidth / 2, y: -7.5, width: currentWidth, height: 15), cornerWidth: 8, cornerHeight: 8, transform: nil)
        
        if currentWidth >= 300 {
            game!.isLose = true
        }
    }
    
    func createRandomBlock() {
        switch level {
        case 1:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 2.92 + CGFloat(i) * 25, y: size.height / 2.115)
                addChild(block)
                blockInsideGrid.append(block)
            }
        case 2:
            for i in 1..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 2.92 + CGFloat(i) * 25, y: size.height / 2.115)
                addChild(block)
                blockInsideGrid.append(block)
                
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: 22, height: 21)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.113 + CGFloat(i) * 23)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
        case 3:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 1.87 + CGFloat(i) * 25, y: size.height / 2.115)
                addChild(block)
                blockInsideGrid.append(block)
                
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: 22, height: 21)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.38 + CGFloat(i) * 23)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
        case 4:
            for i in 0..<4 {
                let item = getRandomBlock()
                
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: 22, height: 21)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.115 + CGFloat(i) * 23.5)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
        case 5:
            for i in 0..<1 {
                let item = getRandomBlock()
                
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: 22, height: 21)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.115 + CGFloat(i) * 23)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
            
        case 6:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 1.87 + CGFloat(i) * 25, y: size.height / 2.235)
                addChild(block)
                blockInsideGrid.append(block)
            }
            for i in 0..<2 {
                let item = getRandomBlock()
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: 22, height: 21)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.115 + CGFloat(i) * 23)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
            
        case 7:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 1.87 + CGFloat(i) * 25, y: size.height / 2.235)
                addChild(block)
                blockInsideGrid.append(block)
            }
            for i in 0..<2 {
                let item = getRandomBlock()
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: 22, height: 21)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.115 + CGFloat(i) * 23)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
            
            for i in 0..<2 {
                let item = getRandomBlock()
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: 22, height: 21)
                block2.position = CGPoint(x: size.width / 2.45, y: size.height / 2.115 + CGFloat(i) * 23)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
            
        case 8:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 1.87 + CGFloat(i) * 25, y: size.height / 2.235)
                addChild(block)
                blockInsideGrid.append(block)
            }
            for i in 0..<2 {
                let item = getRandomBlock()
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: 22, height: 21)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.115 + CGFloat(i) * 23)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
            
            for i in 0..<4 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 2.14, y: size.height / 2.235 + CGFloat(i) * 23)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
        case 9:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 1.88 + CGFloat(i) * 25, y: size.height / 2.38)
                addChild(block)
                blockInsideGrid.append(block)
            }
            for i in 0..<2 {
                let item = getRandomBlock()
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: 22, height: 21)
                block2.position = CGPoint(x: size.width / 2.13, y: size.height / 1.89 + CGFloat(i) * 23)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
            
        case 10:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 1.88 + CGFloat(i) * 25, y: size.height / 2.38)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
            for i in 0..<1 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 1.875 + CGFloat(i) * 25, y: size.height / 1.802)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
            for i in 0..<1 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 2.93 + CGFloat(i) * 25, y: size.height / 2.38)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
        case 11:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 1.88 + CGFloat(i) * 25, y: size.height / 2.38)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
            for i in 0..<2 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 1.88, y: size.height / 1.89 + CGFloat(i) * 23)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
            for i in 0..<2 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 2.93 + CGFloat(i) * 25, y: size.height / 2.38)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
        case 12:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 1.88, y: size.height / 2.38 + CGFloat(i) * 22)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
            for i in 0..<2 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 1.87 + CGFloat(i) * 25, y: size.height / 1.895)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
            for i in 0..<2 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: 22, height: 21)
                block.position = CGPoint(x: size.width / 2.93 + CGFloat(i) * 25, y: size.height / 2.38)
                addChild(block)
                blockInsideGrid.append(block)
            }
        default:
            for i in 0..<3 {
                let item = getRandomBlock()
                    let block = SKSpriteNode(imageNamed: item)
                    block.name = item
                    block.size = CGSize(width: 22, height: 21)
                    block.position = CGPoint(x: size.width / 2.92 + CGFloat(i) * 25, y: size.height / 2.115)
                    addChild(block)
                    blockInsideGrid.append(block)
                }
        }
    }
    
    func createRandomBlockWidth() {
        switch level {
        case 1:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 2.92 + CGFloat(i) * size.width * 0.063, y: size.height / 2.115)
                addChild(block)
                blockInsideGrid.append(block)
            }
        case 2:
            for i in 1..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 2.92 + CGFloat(i) * size.width * 0.063, y: size.height / 2.115)
                addChild(block)
                blockInsideGrid.append(block)
                
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.113 + CGFloat(i) * size.width * 0.037)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
        case 3:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 1.87 + CGFloat(i) * size.width * 0.063, y: size.height / 2.115)
                addChild(block)
                blockInsideGrid.append(block)
                
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.38 + CGFloat(i) * size.width * 0.037)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
        case 4:
            for i in 0..<4 {
                let item = getRandomBlock()
                
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.115 + CGFloat(i) * size.width * 0.037)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
        case 5:
            for i in 0..<1 {
                let item = getRandomBlock()
                
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.115 + CGFloat(i) * size.width * 0.037)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
            
        case 6:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 1.87 + CGFloat(i) * size.width * 0.063, y: size.height / 2.235)
                addChild(block)
                blockInsideGrid.append(block)
            }
            for i in 0..<2 {
                let item = getRandomBlock()
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.115 + CGFloat(i) * size.width * 0.037)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
            
        case 7:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 1.87 + CGFloat(i) * size.width * 0.063, y: size.height / 2.235)
                addChild(block)
                blockInsideGrid.append(block)
            }
            for i in 0..<2 {
                let item = getRandomBlock()
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.115 + CGFloat(i) * 38)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
            
            for i in 0..<2 {
                let item = getRandomBlock()
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block2.position = CGPoint(x: size.width / 2.45, y: size.height / 2.115 + CGFloat(i) * size.width * 0.037)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
            
        case 8:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 1.87 + CGFloat(i) * size.width * 0.063, y: size.height / 2.235)
                addChild(block)
                blockInsideGrid.append(block)
            }
            for i in 0..<2 {
                let item = getRandomBlock()
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block2.position = CGPoint(x: size.width / 2.92, y: size.height / 2.115 + CGFloat(i) * size.width * 0.037)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
            
            for i in 0..<4 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 2.14, y: size.height / 2.235 + CGFloat(i) * size.width * 0.037)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
        case 9:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 1.88 + CGFloat(i) * size.width * 0.063, y: size.height / 2.38)
                addChild(block)
                blockInsideGrid.append(block)
            }
            for i in 0..<2 {
                let item = getRandomBlock()
                let block2 = SKSpriteNode(imageNamed: item)
                block2.name = item
                block2.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block2.position = CGPoint(x: size.width / 2.13, y: size.height / 1.89 + CGFloat(i) * size.width * 0.037)
                addChild(block2)
                blockInsideGrid.append(block2)
            }
            
        case 10:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 1.88 + CGFloat(i) * size.width * 0.063, y: size.height / 2.38)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
            for i in 0..<1 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 1.875 + CGFloat(i) * size.width * 0.063, y: size.height / 1.802)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
            for i in 0..<1 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 2.93 + CGFloat(i) * size.width * 0.063, y: size.height / 2.38)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
        case 11:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 1.88 + CGFloat(i) * size.width * 0.063, y: size.height / 2.38)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
            for i in 0..<2 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 1.88, y: size.height / 1.89 + CGFloat(i) * size.width * 0.037)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
            for i in 0..<2 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 2.93 + CGFloat(i) * 65, y: size.height / 2.38)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
        case 12:
            for i in 0..<3 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 1.88, y: size.height / 2.38 + CGFloat(i) * size.width * 0.037)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
            for i in 0..<2 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 1.87 + CGFloat(i) * size.width * 0.063, y: size.height / 1.895)
                addChild(block)
                blockInsideGrid.append(block)
            }
            
            for i in 0..<2 {
                let item = getRandomBlock()
                let block = SKSpriteNode(imageNamed: item)
                block.name = item
                block.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
                block.position = CGPoint(x: size.width / 2.93 + CGFloat(i) * size.width * 0.063, y: size.height / 2.38)
                addChild(block)
                blockInsideGrid.append(block)
            }
        default:
            for i in 0..<3 {
                let item = getRandomBlock()
                    let block = SKSpriteNode(imageNamed: item)
                    block.name = item
                    block.size = CGSize(width: 65, height: 38)
                    block.position = CGPoint(x: size.width / 2.92 + CGFloat(i) * 25, y: size.height / 2.115)
                    addChild(block)
                    blockInsideGrid.append(block)
                }
        }
    }
    
    func checkIfGridIsEmpty() -> Bool {
        return blockInsideGrid.isEmpty
    }
    
    func moveBlockToGrid(_ blockOutside: SKSpriteNode, _ targetNode: SKSpriteNode) {
        guard blocksOutsideGrid.contains(blockOutside) else {
            return
        }
        
        guard blockInsideGrid.contains(targetNode) else {
            return
        }
        
        var targetPosition = targetNode.position
        var direction: CGPoint = .zero
        
        if size.width > 400 {
            switch blockOutside.name {
            case "blockToRight":
                direction = CGPoint(x: -1, y: 0)
                targetPosition.x -= (blockOutside.size.width / 2 + targetNode.size.width / 1.9)
            case "blockToLeft":
                direction = CGPoint(x: 1, y: 0)
                targetPosition.x += (blockOutside.size.width / 2 + targetNode.size.width / 1.9)
            case "blockToBottom":
                direction = CGPoint(x: 0, y: 1)
                targetPosition.y += (blockOutside.size.height / 2 + targetNode.size.height / 1.8)
            case "blockToTop":
                direction = CGPoint(x: 0, y: -1)
                targetPosition.y -= (blockOutside.size.height / 2 + targetNode.size.width / 3.5)
            default:
                return
            }
        } else if size.width > 1000 {
            switch blockOutside.name {
            case "blockToRight":
                direction = CGPoint(x: -1, y: 0)
                targetPosition.x -= (blockOutside.size.width / 2 + targetNode.size.width / 1.5)
            case "blockToLeft":
                direction = CGPoint(x: 1, y: 0)
                targetPosition.x += (blockOutside.size.width / 2 + targetNode.size.width / 1.6)
            case "blockToBottom":
                direction = CGPoint(x: 0, y: 1)
                targetPosition.y += (blockOutside.size.height / 2 + targetNode.size.height / 1.6)
            case "blockToTop":
                direction = CGPoint(x: 0, y: -1)
                targetPosition.y -= (blockOutside.size.height / 2 + targetNode.size.width / 1.85)
            default:
                return
            }
        } else {
            switch blockOutside.name {
            case "blockToRight":
                direction = CGPoint(x: -1, y: 0)
                targetPosition.x -= (blockOutside.size.width / 2 + targetNode.size.width / 1.5)
            case "blockToLeft":
                direction = CGPoint(x: 1, y: 0)
                targetPosition.x += (blockOutside.size.width / 2 + targetNode.size.width / 1.6)
            case "blockToBottom":
                direction = CGPoint(x: 0, y: 1)
                targetPosition.y += (blockOutside.size.height / 2 + targetNode.size.height / 1.6)
            case "blockToTop":
                direction = CGPoint(x: 0, y: -1)
                targetPosition.y -= (blockOutside.size.height / 2 + targetNode.size.width / 1.85)
            default:
                return
            }
        }
        
        let initialPosition = blockOutside.position
        
        let trailingBlocks = findTrailingBlocks(direction: direction, fromPosition: initialPosition)
        
        if trailingBlocks.isEmpty {
            return
        }
        
        guard blockInsideGrid.contains(targetNode) else {
            return
        }
        
        let _ = moveTrailingBlocks(trailingBlocks: trailingBlocks, direction: direction, emptyPosition: initialPosition)
        
        let moveAction = SKAction.move(to: targetPosition, duration: moveDuration)
        
        blockOutside.run(moveAction)
        
        blockOutside.run(SKAction.sequence([moveAction])) { [self] in
            self.blocksOutsideGrid.removeAll(where: { $0 == blockOutside })
            self.blockInsideGrid.append(blockOutside)
            
            if let textureName = (blockOutside.texture?.description.components(separatedBy: "'")[1].components(separatedBy: "'")[0]) {
                blockOutside.name = textureName
            }
            
            self.blockMapping[blockOutside] = nil
            self.blockMapping[blockOutside] = targetNode
            
            self.assignClosestBlocks()
            
            self.checkForMatches()
            
            var newBlockPosition = initialPosition
            if size.width > 400 {
                if direction.x != 0 {
                   
                    newBlockPosition.x += 1 * direction.x * (blockOutside.size.width + size.width * 0.063)
                } else if direction.y != 0 {
                    newBlockPosition.y += 1 * direction.y * (blockOutside.size.height + size.width * 0.037)
                }
            } else {
                if direction.x != 0 {
                    newBlockPosition.x += 1 * direction.x * (blockOutside.size.width + 26.5)
                } else if direction.y != 0 {
                    newBlockPosition.y += 1 * direction.y * (blockOutside.size.height + 26.5)
                }
            }
            
            
            self.createNewBlock(at: newBlockPosition)
        }
    }
    
    func findTrailingBlocks(direction: CGPoint, fromPosition position: CGPoint) -> [SKSpriteNode] {
        let trailingBlocks = blocksOutsideGrid.filter { block in
            let dx = block.position.x - position.x
            let dy = block.position.y - position.y
            
            if direction.x != 0 {
                return dy == 0 && dx * direction.x > 0
            } else if direction.y != 0 {
                return dx == 0 && dy * direction.y > 0
            }
            return false
        }
        return trailingBlocks
    }
    
    func moveTrailingBlocks(trailingBlocks: [SKSpriteNode], direction: CGPoint, emptyPosition: CGPoint) -> CGPoint? {
        guard !trailingBlocks.isEmpty else {
            return nil
        }
        
        let sortedTrailingBlocks = trailingBlocks.sorted { block1, block2 in
            let distance1 = calculateDistance(block1.position, emptyPosition)
            let distance2 = calculateDistance(block2.position, emptyPosition)
            return distance1 < distance2
        }
        
        var currentEmptyPosition = emptyPosition
        var lastMovedBlockPosition: CGPoint?
        
        for block in sortedTrailingBlocks {
            let newPosition = currentEmptyPosition
            currentEmptyPosition = block.position
            let moveAction = SKAction.move(to: newPosition, duration: 0.5)
            block.run(moveAction) {
                self.assignClosestBlocks()
            }
            
            lastMovedBlockPosition = newPosition
        }
        
        return lastMovedBlockPosition
    }
    
    func getRandomBlock() -> String {
        return [SugarImageName.blockToTop.rawValue, SugarImageName.blockToBottom.rawValue, SugarImageName.blockToLeft.rawValue, SugarImageName.blockToRight.rawValue].randomElement() ?? "blockToTop"
    }
    
    func createNewBlock(at position: CGPoint) {
        if size.width > 400 {
            let randomBlock = getRandomBlock()
            let newBlock = SKSpriteNode(imageNamed: randomBlock)
            newBlock.size = CGSize(width: size.width * 0.063, height: size.width * 0.037)
            newBlock.position = position
            addChild(newBlock)
            blocksOutsideGrid.append(newBlock)
        } else {
            let randomBlock = getRandomBlock()
            let newBlock = SKSpriteNode(imageNamed: randomBlock)
            newBlock.size = CGSize(width: 22, height: 21)
            newBlock.position = position
            addChild(newBlock)
            blocksOutsideGrid.append(newBlock)
        }
    }
    
    func checkForMatches() {
        var processedBlocks: Set<SKSpriteNode> = []
        for block in blockInsideGrid {
            guard !processedBlocks.contains(block) else { continue }
            if let match = findMatch(for: block) {
                removeMatches(match: match)
                processedBlocks.formUnion(match)
            }
        }
        
        assignClosestBlocks()
    }
    
    func findMatch(for block: SKSpriteNode) -> [SKSpriteNode]? {
        var matchingBlocks: [SKSpriteNode] = [block]
        for otherBlock in blockInsideGrid {
            guard block != otherBlock else { continue }
            if block.name == otherBlock.name {
                let distance = calculateDistance(block1: block, block2: otherBlock)
                let tolerance: CGFloat = 5.0
                if distance < (block.size.width / 2 + otherBlock.size.width / 2) + tolerance {
                    matchingBlocks.append(otherBlock)
                }
            }
        }
        
        if matchingBlocks.count == 3 {
            return matchingBlocks
        }
        
        return nil
    }
    
    func calculateDistance(_ point1: CGPoint, _ point2: CGPoint) -> CGFloat {
        let dx = point1.x - point2.x
        let dy = point1.y - point2.y
        return sqrt(dx * dx + dy * dy)
    }
    
    func calculateDistance(block1: SKSpriteNode, block2: SKSpriteNode) -> CGFloat {
        let dx = block1.position.x - block2.position.x
        let dy = block1.position.y - block2.position.y
        return sqrt(dx * dx + dy * dy)
    }
    
    func removeMatches(match: [SKSpriteNode]) {
        for block in match {
            blockInsideGrid.removeAll(where: { $0 == block })
            let fadeOut = SKAction.fadeOut(withDuration: 0.3)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([fadeOut, remove])
            
            block.run(sequence) {
                if self.checkIfGridIsEmpty() {
                    self.game!.isWin = true
                }
            }
        }
        
        game!.score += 50
        scoreLabel.attributedText = NSAttributedString(string: "SCORE: \(game?.score ?? 0)", attributes: [
            NSAttributedString.Key.font: UIFont(name: "BowlbyOneSC-Regular", size: 12)!,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeColor: UIColor(red: 145/255, green: 17/255, blue: 38/255, alpha: 1),
            NSAttributedString.Key.strokeWidth: -4
        ])
    }

    func assignClosestBlocks() {
        for targetBlock in blockInsideGrid {
            let leftBlocks = blocksOutsideGrid.filter {
                $0.position.x < targetBlock.position.x &&
                abs($0.position.y - targetBlock.position.y) < 5
            }
            
            let rightBlocks = blocksOutsideGrid.filter {
                $0.position.x > targetBlock.position.x &&
                abs($0.position.y - targetBlock.position.y) < 5
            }
            
            let topBlocks = blocksOutsideGrid.filter {
                $0.position.y > targetBlock.position.y &&
                abs($0.position.x - targetBlock.position.x) < 5
            }
            
            let bottomBlocks = blocksOutsideGrid.filter {
                $0.position.y < targetBlock.position.y &&
                abs($0.position.x - targetBlock.position.x) < 5
            }
            
            if let closestLeftBlock = leftBlocks.sorted(by: { $0.position.x > $1.position.x }).first(where: { block in
                !blockInsideGrid.contains(where: { $0 != targetBlock && $0.position.x > block.position.x && $0.position.x < targetBlock.position.x && abs($0.position.y - block.position.y) < 5 })
            }) {
                closestLeftBlock.name = "blockToRight"
                blockMapping[closestLeftBlock] = targetBlock
            }
            
            if let closestRightBlock = rightBlocks.sorted(by: { $0.position.x < $1.position.x }).first(where: { block in
                !blockInsideGrid.contains(where: { $0 != targetBlock && $0.position.x < block.position.x && $0.position.x > targetBlock.position.x && abs($0.position.y - block.position.y) < 5 })
            }) {
                closestRightBlock.name = "blockToLeft"
                blockMapping[closestRightBlock] = targetBlock
            }
            
            if let closestTopBlock = topBlocks.sorted(by: { $0.position.y < $1.position.y }).first(where: { block in
                !blockInsideGrid.contains(where: { $0 != targetBlock && $0.position.y < block.position.y && $0.position.y > targetBlock.position.y && abs($0.position.x - block.position.x) < 5 })
            }) {
                closestTopBlock.name = "blockToBottom"
                blockMapping[closestTopBlock] = targetBlock
            }
            
            if let closestBottomBlock = bottomBlocks.sorted(by: { $0.position.y > $1.position.y }).first(where: { block in
                !blockInsideGrid.contains(where: { $0 != targetBlock && $0.position.y > block.position.y && $0.position.y < targetBlock.position.y && abs($0.position.x - block.position.x) < 5 })
            }) {
                closestBottomBlock.name = "blockToTop"
                blockMapping[closestBottomBlock] = targetBlock
            }
        }
    }
    
    func findClosestBlockInGrid(to block: SKSpriteNode) -> SKSpriteNode? {
        var closestBlock: SKSpriteNode?
        var minDistance: CGFloat = CGFloat.greatestFiniteMagnitude
        for gridBlock in blockInsideGrid {
            if abs(block.position.x - gridBlock.position.x) < 5 || abs(block.position.y - gridBlock.position.y) < 5 {
                let distance = calculateDistance(block.position, gridBlock.position)
                if distance < minDistance {
                    minDistance = distance
                    closestBlock = gridBlock
                }
            }
        }
        return closestBlock
    }
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        setupView()
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: self)
        if let touchedNode = self.atPoint(touchLocation) as? SKSpriteNode {
            tapOnTime(touchLocation: touchLocation)
            tapOnPause(touchLocation: touchLocation)
            tapOnRules(touchLocation: touchLocation)
            tapOnHummmer(touchLocation: touchLocation)
            
            if blocksOutsideGrid.contains(touchedNode) {
                if let closestBlock = findClosestBlockInGrid(to: touchedNode) {
                    let distance = calculateDistance(touchedNode.position, closestBlock.position)
                    if distance > 50 {
                        if let targetNode = blockMapping[touchedNode] {
                            moveBlockToGrid(touchedNode, targetNode)
                        }
                    }
                } else {
                    if let targetNode = blockMapping[touchedNode] {
                        moveBlockToGrid(touchedNode, targetNode)
                    }
                }
            }
        }
    }
}

struct SugarGameView: View {
    @StateObject var sugarGameModel =  SugarGameViewModel()
    @StateObject var gameModel =  SugarGameData()
    var level: Int
    var body: some View {
        ZStack {
            SpriteView(scene: sugarGameModel.createSugarGameScene(gameData: gameModel, level: level))
                .ignoresSafeArea()
            .navigationBarBackButtonHidden(true)
            
            if gameModel.isWin {
                SugarWinView(level: level, point: gameModel.score)
                    .onAppear {
                        if (UserDefaultsManager.defaults.object(forKey: Keys.currentLevel.rawValue) as? Int ?? 0) == level {
                            UserDefaultsManager().completeLevel()
                        }
                    }
            }
            
            if gameModel.isLose {
                SugarLoseView(level: level)
            }
            
            if gameModel.isPause {
                SugarPauseView(game: gameModel, scene: gameModel.scene)
            }
            
            if gameModel.isRules {
                SugarRulesView(game: gameModel, scene: gameModel.scene)
            }
        }
    }
}

#Preview {
    SugarGameView(level: 1)
}


//
//  GameScene.swift
//  Project19
//
//  Created by Roberto Manese III on 5/31/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import SpriteKit
import GameplayKit
import AVFoundation

enum ForceBomb {
    case never, always, random
}

enum SequenceType: CaseIterable {
    case oneNoBomb, one, twoWithOneBomb, two, three, four, chain, fastChain
}

class GameScene: SKScene {

    var scoreLabel: SKLabelNode!
    var activeSliceFG: SKShapeNode!
    var activeSliceBG: SKShapeNode!

    var bombSoundsEffect: AVAudioPlayer?

    var livesImages = [SKSpriteNode]()
    var activeSlicePoints = [CGPoint]()
    var activeEnemies = [SKSpriteNode]()
    var sequence = [SequenceType]()

    var isSwooshSoundActive = false
    var isGameEnded = false

    var popupTime = 0.9
    var chainDelay = 3.0
    var sequencePosition = 0
    var nextSequenceQueued = true

    var lives = 3
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "sliceBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        physicsWorld.gravity = CGVector(dx: 0, dy: -6)
        physicsWorld.speed = 0.85

        createScore()
        createLives()
        createSlices()

        sequence = [.oneNoBomb, .oneNoBomb, .twoWithOneBomb, .twoWithOneBomb, .three, .one, .chain]

        for _ in 0...1000 {
            if let sequenceType = SequenceType.allCases.randomElement() {
                sequence.append(sequenceType)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            [weak self] in self?.tossEnemies()
        }
    }

    override func update(_ currentTime: TimeInterval) {
        var bombCounter = 0

        if activeEnemies.count > 0 {
            for (index, node) in activeEnemies.enumerated().reversed() {
                if node.position.y <= -140 {
                    node.removeAllActions()
                    if node.name == "enemy" {
                        subtractLife()
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    } else if node.name == "bombContainer" {
                        node.name = ""
                        node.removeFromParent()
                        activeEnemies.remove(at: index)
                    }
                }
            }
        } else {
            if !nextSequenceQueued {
                DispatchQueue.main.asyncAfter(deadline: .now() + popupTime) {
                    [weak self] in self?.tossEnemies()
                }
                nextSequenceQueued = true
            }
        }

        for node in activeEnemies {
            if node.name == "bombContainer" {
                bombCounter += 1
                break
            }
        }

        if bombCounter == 0 {
            bombSoundsEffect?.stop()
            bombSoundsEffect = nil
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        activeSlicePoints.removeAll(keepingCapacity: true)

        let location = touch.location(in: self)
        activeSlicePoints.append(location)

        redrawActiveSlice()

        activeSliceFG.removeAllActions()
        activeSliceBG.removeAllActions()

        activeSliceFG.alpha = 1
        activeSliceBG.alpha = 1
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        activeSlicePoints.append(location)

        redrawActiveSlice()

        if !isSwooshSoundActive {
            playSwooshSound()
        }

        let nodesAtLocation = nodes(at: location)
        for case let node as SKSpriteNode in nodesAtLocation {
            if node.name == "enemy" {
                if let emitter = SKEmitterNode(fileNamed: "sliceHitEnemy") {
                    emitter.position = node.position
                    addChild(emitter)
                }

                node.name = ""
                node.physicsBody?.isDynamic = false

                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])

                let seq = SKAction.sequence([group, .removeFromParent()])
                node.run(seq)

                score += 1
                if let index = activeEnemies.firstIndex(of: node) {
                    activeEnemies.remove(at: index)
                }

                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false ))
            } else if node.name == "bomb" {
                guard let bombContainter = node.parent as? SKSpriteNode else { continue }
                if let emitter = SKEmitterNode(fileNamed: "sliceHitBomb") {
                    emitter.position = node.position
                    addChild(emitter)
                }

                node.name = ""
                bombContainter.physicsBody?.isDynamic = false

                let scaleOut = SKAction.scale(to: 0.001, duration: 0.2)
                let fadeOut = SKAction.fadeOut(withDuration: 0.2)
                let group = SKAction.group([scaleOut, fadeOut])

                let seq = SKAction.sequence([group, .removeFromParent()])
                node.run(seq)

                run(SKAction.playSoundFileNamed("explosion.caf", waitForCompletion: false))
                endGame(triggeredByBomb: true)
            }
        }
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
    }

    func subtractLife() {
        lives -= 1
        run(SKAction.playSoundFileNamed("wrong.caf", waitForCompletion: false))

        var life: SKSpriteNode

        if lives == 2 {
            life = livesImages[0]
        } else if lives == 1 {
            life = livesImages[1]
        } else {
            life = livesImages[2]
            endGame(triggeredByBomb: false)
        }

        life.texture = SKTexture(imageNamed: "sliceLifeGone")
        life.xScale = 1.3
        life.yScale = 1.3
        life.run(SKAction.scale(to: 1, duration: 0.1))
    }

    func endGame(triggeredByBomb: Bool) {
        guard isGameEnded == false else { return }

        physicsWorld.speed = 0

        bombSoundsEffect?.stop()
        bombSoundsEffect = nil

        if triggeredByBomb {
            for node in livesImages {
                node.texture = SKTexture(imageNamed: "sliceLifeGone")
            }
        }

        let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
        gameOverLabel.name = "Game Over"
        gameOverLabel.position = CGPoint(x: 512, y: 384)
        gameOverLabel.zPosition = 1
        gameOverLabel.fontSize = 48
        gameOverLabel.text = "Game Over"
    }

    func playSwooshSound() {
        isSwooshSoundActive = true

        let randomNumber = Int.random(in: 1...3)
        let soundName = "swoosh\(randomNumber).caf"

        let swooshSound = SKAction.playSoundFileNamed(soundName, waitForCompletion: true)

        run(swooshSound) {
            [weak self] in

            self?.isSwooshSoundActive = false
        }
    }

    func createScore() {
        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.horizontalAlignmentMode = .left
        scoreLabel.position = CGPoint(x: 8, y: 8)
        scoreLabel.fontSize = 48
        addChild(scoreLabel)
        score = 0
    }

    func createLives() {
        for i in 0..<3 {
            let livesNode = SKSpriteNode(imageNamed: "sliceLife")
            livesNode.position = CGPoint(x: 834 + (i * 70), y: 720)
            addChild(livesNode)
            livesImages.append(livesNode)
        }
    }

    func createSlices() {
        activeSliceBG = SKShapeNode()
        activeSliceBG.zPosition = 2
        activeSliceBG.lineWidth = 9
        activeSliceBG.strokeColor = UIColor(red: 0, green: 0, blue: 1, alpha: 1)

        activeSliceFG = SKShapeNode()
        activeSliceFG.zPosition = 3
        activeSliceFG.lineWidth = 5
        activeSliceFG.strokeColor = .white

        addChild(activeSliceBG)
        addChild(activeSliceFG)
    }

    func redrawActiveSlice() {
        if activeSlicePoints.count < 2 {
            activeSliceFG.path = nil
            activeSliceBG.path = nil
            return
        }

        if activeSlicePoints.count > 12 {
            activeSlicePoints.removeFirst(activeSlicePoints.count - 12)
        }

        let path = UIBezierPath()
        path.move(to: activeSlicePoints[0])

        for i in 1..<activeSlicePoints.count {
            path.addLine(to: activeSlicePoints[i])
        }

        activeSliceFG.path = path.cgPath
        activeSliceBG.path = path.cgPath
    }

    func createEnemy(forceBomb: ForceBomb = .random) {
        let enemy: SKSpriteNode

        var enemyType = Int.random(in: 0...6)

        if forceBomb == .never {
            enemyType = 1
        } else if forceBomb == .always {
            enemyType = 0
        }

        if enemyType == 0 {
            enemy = SKSpriteNode()
            enemy.zPosition = 1
            enemy.name = "bombContainer"

            let bombImage = SKSpriteNode(imageNamed: "sliceBomb")
            bombImage.name = "bomb"
            enemy.addChild(bombImage)

            if bombSoundsEffect != nil {
                bombSoundsEffect?.stop()
                bombSoundsEffect = nil
            }

            if let path = Bundle.main.url(forResource: "sliceBombFuse", withExtension: ".caf") {
                if let sound = try? AVAudioPlayer(contentsOf: path) {
                    bombSoundsEffect = sound
                    sound.play()
                }
            }

            if let emitter = SKEmitterNode(fileNamed: "sliceFuse") {
                emitter.position = CGPoint(x: 76, y: 64)
                enemy.addChild(emitter)
            }

        } else {
            enemy = SKSpriteNode(imageNamed: "penguin")
            run(SKAction.playSoundFileNamed("launch.caf", waitForCompletion: false))
            enemy.name = "enemy"
        }

        let randomPosition = CGPoint(x: Int.random(in: 64...960), y: -128)
        enemy.position = randomPosition

        let randomAngularVelocity = CGFloat.random(in: -3...3)
        let randomYVelocity = Int.random(in: 24...32)
        let randomXVelocity: Int


        if randomPosition.x < 256 {
            randomXVelocity = Int.random(in: 8...15)
        } else if randomPosition.x < 512 {
            randomXVelocity = Int.random(in: 3...5)
        } else if randomPosition.x < 768 {
            randomXVelocity = -Int.random(in: 3...5)
        } else {
            randomXVelocity = -Int.random(in: 8...15)
        }

        enemy.physicsBody = SKPhysicsBody(circleOfRadius: 64)
        enemy.physicsBody?.velocity = CGVector(dx: randomXVelocity * 40, dy: randomYVelocity * 40)
        enemy.physicsBody?.angularVelocity = randomAngularVelocity
        enemy.physicsBody?.collisionBitMask = 0

        addChild(enemy)
        activeEnemies.append(enemy)
    }

    func tossEnemies() {
        popupTime *= 0.991
        chainDelay *= 0.99
        physicsWorld.speed *= 1.02

        let sequenceType = sequence[sequencePosition]

        switch sequenceType {
        case .oneNoBomb:
            createEnemy(forceBomb: .never)

        case .one:
            createEnemy()

        case .twoWithOneBomb:
            createEnemy(forceBomb: .never)
            createEnemy(forceBomb: .always)

        case .two:
            createEnemy()
            createEnemy()

        case .three:
            createEnemy()
            createEnemy()
            createEnemy()

        case .four:
            createEnemy()
            createEnemy()
            createEnemy()
            createEnemy()

        case .chain:
            createEnemy()

            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 5.0 * 4)) { [weak self] in self?.createEnemy() }

        case .fastChain:
            createEnemy()

            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 2)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 3)) { [weak self] in self?.createEnemy() }
            DispatchQueue.main.asyncAfter(deadline: .now() + (chainDelay / 10.0 * 4)) { [weak self] in self?.createEnemy() }
        }

        sequencePosition += 1
        nextSequenceQueued = false
    }

}

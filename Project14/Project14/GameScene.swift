//
//  GameScene.swift
//  Project14
//
//  Created by Roberto Manese III on 5/8/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {

    var starfield: SKEmitterNode!
    var player: SKSpriteNode!
    var scoreLabel: SKLabelNode!
    var playAgain = SKLabelNode(fontNamed: "Chalkduster")
    let gameOverLabel = SKLabelNode(fontNamed: "Chalkduster")
    var gameTimer: Timer?

    var interval = 0.1
    var enemyCount = 0

    var enemies = ["ball", "hammer", "tv"]
    var isGameOver = false

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        starfield = SKEmitterNode(fileNamed: "starfield")
        starfield.name = "starfield"
        starfield.position = CGPoint(x: 1024, y: 384)
        starfield.zPosition = -1
        starfield.advanceSimulationTime(10)

        player = SKSpriteNode(imageNamed: "player")
        player.position = CGPoint(x: 100, y: 384)
        if let texture = player.texture {
            player.physicsBody = SKPhysicsBody(texture: texture, size: player.size)
            player.physicsBody?.contactTestBitMask = 1
        }

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left

        addChild(starfield)
        addChild(player)
        addChild(scoreLabel)

        score = 0

        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self

        gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }

    override func update(_ currentTime: TimeInterval) {
        for node in children {
            if node.position.x < -300 {
                node.removeFromParent()
            }
        }

        if !isGameOver {
            score += 1
        }
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touches = touches.first else { return }
        var location = touches.location(in: self)
        let tappedNodes = nodes(at: location)

        if location.y < 100 {
            location.y = 100
        } else if location.y > 668 {
            location.y = 668
        }

        if tappedNodes.contains(player) {
            player.position = location
        }

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        if tappedNodes.contains(playAgain) {
            playAgain.removeFromParent()
            gameOverLabel.removeFromParent()
            player.position = CGPoint(x: 100, y: 364)
            addChild(player)
            gameTimer = Timer.scheduledTimer(timeInterval: 0.35, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
        }
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let view = view else { return }
        guard let explosion = SKEmitterNode(fileNamed: "explosion") else { return }
        explosion.position = player.position
        addChild(explosion)

        isGameOver = true
        gameTimer?.invalidate()
        for node in children {
            if node.name == "enemy" { node.removeFromParent() }
        }

        gameOverLabel.numberOfLines = 0
        gameOverLabel.text = """
        Game Over!
        Final Score: \(score)
        """
        gameOverLabel.position = view.center
        gameOverLabel.zPosition = 1

        playAgain.text = "Play again?"
        playAgain.position = CGPoint(x: gameOverLabel.position.x, y: gameOverLabel.position.y - 50)

        addChild(playAgain)
        addChild(gameOverLabel)
        player.removeFromParent()
    }

    @objc func createEnemy() {
        guard let enemy = enemies.randomElement() else { return }
        enemyCount += 1

        if enemyCount % 20 == 0 {
            changeInterval()
        }

        let sprite = SKSpriteNode(imageNamed: enemy)
        sprite.name = "enemy"
        sprite.position = CGPoint(x: 1200, y: Int.random(in: 50...736))
        addChild(sprite)

        if let texture = sprite.texture {
            sprite.physicsBody = SKPhysicsBody(texture: texture, size: sprite.size)
            sprite.physicsBody?.contactTestBitMask = 1
            sprite.physicsBody?.velocity = CGVector(dx: -500, dy: 0)
            sprite.physicsBody?.angularVelocity = 5
            sprite.physicsBody?.angularDamping = 0
            sprite.physicsBody?.linearDamping = 0
        }
    }

    private func changeInterval() {
        interval += 0.1
        let newInterval = 0.35 - interval
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(timeInterval: newInterval, target: self, selector: #selector(createEnemy), userInfo: nil, repeats: true)
    }
}

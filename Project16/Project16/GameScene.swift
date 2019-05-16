//
//  GameScene.swift
//  Project16
//
//  Created by Roberto Manese III on 5/14/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var gameTimer: Timer?
    var fireworks: [SKNode] = []
    var scoreLabel: SKLabelNode!

    let leftEdge = -22
    let bottomEdge = -22
    let rightEdge = 1024 + 22

    var rounds = 1

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.zPosition = -1
        background.blendMode = .replace
        addChild(background)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.position = CGPoint(x: 16, y: 16)
        scoreLabel.horizontalAlignmentMode = .left
        score = 0
        addChild(scoreLabel)

        gameTimer = Timer.scheduledTimer(timeInterval: 6, target: self, selector: #selector(launchFirework), userInfo: nil, repeats: true)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        checkTouches(touches)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesMoved(touches, with: event)
    }

    override func update(_ currentTime: TimeInterval) {
        for (index, firework) in fireworks.enumerated().reversed() {
            if firework.position.y > 900 {
                fireworks.remove(at: index)
                firework.removeFromParent()
            }
        }
    }

    private func createFirework(xMovement: CGFloat, x: Int, y: Int) {
        let node = SKNode()
        node.position = CGPoint(x: x, y: y)

        let firework = SKSpriteNode(imageNamed: "rocket")
        firework.name = "firework"
        firework.colorBlendFactor = 1
        node.addChild(firework)

        switch Int.random(in: 0...2) {
        case 0:
            firework.color = .cyan
        case 1:
            firework.color = .green
        case 2:
            firework.color = .red
        default:
            firework.color = .yellow
        }

        let path = UIBezierPath()
        path.move(to: .zero)
        path.addLine(to: CGPoint(x: xMovement, y: 1000))

        let move = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: 200)
        node.run(move)

        if let emitter = SKEmitterNode(fileNamed: "fuse") {
            emitter.position = CGPoint(x: 0, y: -22)
            node.addChild(emitter)
        }

        fireworks.append(node)
        addChild(node)
    }

    @objc func launchFirework() {
        let movementAmount: CGFloat = 1800
        rounds += 1

        if rounds >= 10 {
            gameOver()
        }

        switch Int.random(in: 0...3) {
        case 0:
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 - 200, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 100, y: bottomEdge)
            createFirework(xMovement: 0, x: 512 + 200, y: bottomEdge)
        case 1:
            createFirework(xMovement: 0, x: 512, y: bottomEdge)
            createFirework(xMovement: 100, x: 512, y: bottomEdge)
            createFirework(xMovement: 200, x: 512, y: bottomEdge)
            createFirework(xMovement: -100, x: 512, y: bottomEdge)
            createFirework(xMovement: -200, x: 512, y: bottomEdge)
        case 2:
            createFirework(xMovement: movementAmount, x: leftEdge, y: bottomEdge)
            createFirework(xMovement: movementAmount, x: leftEdge - 100, y: bottomEdge)
            createFirework(xMovement: movementAmount, x: leftEdge - 200, y: bottomEdge)
            createFirework(xMovement: movementAmount, x: leftEdge + 100, y: bottomEdge)
            createFirework(xMovement: movementAmount, x: leftEdge + 200, y: bottomEdge)
        case 3:
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge + 200)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge - 100)
            createFirework(xMovement: -movementAmount, x: rightEdge, y: bottomEdge - 200)
        default:
            break
        }
    }

    private func checkTouches(_ touches: Set<UITouch>) {
        guard let touch = touches.first else { return }

        let location = touch.location(in: self)
        let nodesAtPoint = nodes(at: location)

        for case let node as SKSpriteNode in nodesAtPoint {
            guard node.name == "firework" else { continue }

            for parent in fireworks {
                guard let firework = parent.children.first as? SKSpriteNode else { continue }

                if firework.name == "selected" && firework.color != node.color {
                    firework.name = "firework"
                    firework.colorBlendFactor = 1
                }
            }

            node.name = "selected"
            node.colorBlendFactor = 0
        }
    }

    private func explode(firework: SKNode) {
        if let emitter = SKEmitterNode(fileNamed: "explode") {
            emitter.position = firework.position
            addChild(emitter)

            let pause = SKAction.wait(forDuration: 2)
            let remove = SKAction.removeFromParent()
            let sequence = SKAction.sequence([pause, remove])
            emitter.run(sequence)
        }
        firework.removeFromParent()
    }

    func explodeFireworks() {
        var numExploded = 0

        for (index, fireworkContainer) in fireworks.enumerated().reversed() {
            guard let firework = fireworkContainer.children.first as? SKSpriteNode else { continue }

            if firework.name == "selected" {
                explode(firework: fireworkContainer)
                fireworks.remove(at: index)
                numExploded += 1
            }
        }

        switch numExploded {
        case 0:
            break
        case 1:
            score += 200
        case 2:
            score += 500
        case 3:
            score += 1500
        case 4:
            score += 2500
        default:
            score += 4000
        }
    }

    private func removeFireworks() {
        for firework in fireworks {
            firework.removeFromParent()
        }
    }

    private func gameOver() {
        guard let view = view else { return }
        gameTimer?.invalidate()
        let gameover = SKLabelNode(fontNamed: "Chalkduster")
        gameover.text =
        """
            GameOver!
            Final Score: \(score)
        """
        gameover.numberOfLines = 0
        gameover.position = view.center
        gameover.zPosition = 1
        removeFireworks()
        addChild(gameover)
    }
}

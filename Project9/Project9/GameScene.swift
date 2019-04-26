//
//  GameScene.swift
//  Project9
//
//  Created by Roberto Manese III on 4/24/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    var scoreLabel: SKLabelNode!
    var livesLabel: SKLabelNode!

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var lives = 5 {
        didSet {
            if lives > 0 {
                livesLabel.text = "Lives: \(lives)"
            } else {
                livesLabel.text = "G4M3 0V3R"
            }
        }
    }

    var editLabel: SKLabelNode!

    var editingMode: Bool = false {
        didSet {
            if editingMode {
                editLabel.text = "Done"
            } else {
                editLabel.text = "Edit"
            }
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Score: \(score)"
        scoreLabel.horizontalAlignmentMode = .right
        scoreLabel.position = CGPoint(x: 980, y: 700)
        addChild(scoreLabel)

        livesLabel = SKLabelNode(fontNamed: "Chalkduster")
        livesLabel.text = "Lives: \(lives)"
        livesLabel.horizontalAlignmentMode = .right
        livesLabel.position = CGPoint(x: 980, y: 650)
        addChild(livesLabel)


        editLabel = SKLabelNode(fontNamed: "Chalkduster")
        editLabel.text = "Edit"
        editLabel.position = CGPoint(x: 80, y: 700)
        addChild(editLabel)

        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
        physicsWorld.contactDelegate = self

        makeSlot(at: CGPoint(x: 128, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 384, y: 0), isGood: false)
        makeSlot(at: CGPoint(x: 640, y: 0), isGood: true)
        makeSlot(at: CGPoint(x: 896, y: 0), isGood: false)

        makeBouncer(at: CGPoint(x: 0, y: 0))
        makeBouncer(at: CGPoint(x: 256, y: 0))
        makeBouncer(at: CGPoint(x: 512, y: 0))
        makeBouncer(at: CGPoint(x: 768, y: 0))
        makeBouncer(at: CGPoint(x: 1024, y: 0))
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)

        let objects = nodes(at: location)

        if objects.contains(editLabel) {
            editingMode.toggle()
        } else {
            if editingMode {
                let size = CGSize(width: Int.random(in: 16...128), height: 16)
                let box = SKSpriteNode(color: UIColor(red: CGFloat.random(in: 0...1), green: CGFloat.random(in: 0...1), blue: CGFloat.random(in: 0...1), alpha: 1), size: size)
                box.name = "box"
                box.zRotation = CGFloat.random(in: 0...3)
                box.position = location

                box.physicsBody = SKPhysicsBody(rectangleOf: box.size)
                box.physicsBody?.isDynamic = false
                addChild(box)
            } else {
                let color = generateRandomColor()
                let ball = SKSpriteNode(imageNamed: color)
                ball.physicsBody = SKPhysicsBody(circleOfRadius: ball.size.width / 2.0)
                ball.physicsBody?.restitution = 0.4
                ball.physicsBody?.contactTestBitMask = ball.physicsBody?.collisionBitMask ?? 0
                ball.position = CGPoint(x: location.x, y: frame.maxY)
                ball.name = "ball"
                addChild(ball)
            }
        }
    }

    private func makeBouncer(at position: CGPoint) {
        let bouncer = SKSpriteNode(imageNamed: "bouncer")
        bouncer.position = position
        bouncer.physicsBody = SKPhysicsBody(circleOfRadius: bouncer.size.width / 2.0)
        bouncer.physicsBody?.isDynamic = false
        addChild(bouncer)
    }

    private func makeSlot(at position: CGPoint, isGood: Bool) {
        var slotBase: SKSpriteNode
        var slotGlow: SKSpriteNode

        if isGood {
            slotBase = SKSpriteNode(imageNamed: "slotBaseGood")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowGood")
            slotBase.name = "good"
        } else {
            slotBase = SKSpriteNode(imageNamed: "slotBaseBad")
            slotGlow = SKSpriteNode(imageNamed: "slotGlowBad")
            slotBase.name = "bad"
        }

        slotBase.position = position
        slotBase.physicsBody = SKPhysicsBody(rectangleOf: slotBase.size)
        slotBase.physicsBody?.isDynamic = false

        slotGlow.position = position

        let spin = SKAction.rotate(byAngle: .pi / 2, duration: 10)
        let spinForever = SKAction.repeatForever(spin)
        slotGlow.run(spinForever)

        addChild(slotBase)
        addChild(slotGlow)
    }

    private func generateRandomColor() -> String {
        let colors: [String] = ["ballBlue", "ballCyan", "ballPurple", "ballYellow", "ballGrey", "ballGreen", "ballRed"]
        return colors.randomElement() ?? ""
    }

    func collision(between ball: SKNode, object: SKNode) {
        if object.name == "good" {
            destroy(object: ball)
            score += 1
        } else if object.name == "bad" {
            destroy(object: ball)
            score -= 1
            lives -= 1
        } else if object.name == "box" {
            destroy(object: object)
        }
    }

    func destroy(object: SKNode) {
        if let fireParticles = SKEmitterNode(fileNamed: "FireParticles"), object.name == "ball" {
            fireParticles.position = object.position
            addChild(fireParticles)
        }

        object.removeFromParent()
    }

    func didBegin(_ contact: SKPhysicsContact) {
        guard let bodyA = contact.bodyA.node else { return }
        guard let bodyB = contact.bodyB.node else { return }
        if bodyA.name == "ball" {
            collision(between: bodyA, object: bodyB)
        } else if bodyB.name == "ball" {
            collision(between: bodyB, object: bodyA)
        }
    }

}

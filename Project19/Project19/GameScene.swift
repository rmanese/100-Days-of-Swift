//
//  GameScene.swift
//  Project19
//
//  Created by Roberto Manese III on 5/31/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    var scoreLabel: SKLabelNode!
    var livesLabel: SKLabelNode!
    var activeSliceFG: SKShapeNode!
    var activeSliceBG: SKShapeNode!

    var livesImages = [SKSpriteNode]()
    var activeSlicePoints = [CGPoint]()

    var isSwooshSoundActive = false

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }

    var lives = 0 {
        didSet {
            livesLabel.text = "Lives: \(lives)"
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

    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        activeSliceFG.run(SKAction.fadeOut(withDuration: 0.25))
        activeSliceBG.run(SKAction.fadeOut(withDuration: 0.25))
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

}

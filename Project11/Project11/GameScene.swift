//
//  GameScene.swift
//  Project11
//
//  Created by Roberto Manese III on 5/1/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    var slots: [WhackSlot] = []

    var gameScore = SKLabelNode(fontNamed: "Chalkduster")
    var roundsLabel = SKLabelNode(fontNamed: "Chalkduster")
    var playAgainLabel = SKLabelNode(fontNamed: "Chalkduster")
    var finalScore = SKLabelNode(fontNamed: "Chalkduster")
    var gameOver = SKSpriteNode(imageNamed: "gameOver")

    var rounds: Int = 0 {
        didSet {
            roundsLabel.text = "Round \(rounds) of 10"
        }
    }
    var popupTime = 0.85

    var score: Int = 0 {
        didSet {
            gameScore.text = "Score: \(score)"
        }
    }

    override func didMove(to view: SKView) {
        let background = SKSpriteNode(imageNamed: "whackBackground")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)

        gameScore.text = "Score: \(score)"
        gameScore.position = CGPoint(x: 8, y: 8)
        gameScore.horizontalAlignmentMode = .left
        gameScore.fontSize = 48
        addChild(gameScore)

        roundsLabel.text = "Round 1 of 10"
        roundsLabel.position = CGPoint(x: 8, y: 700)
        roundsLabel.horizontalAlignmentMode = .left
        roundsLabel.fontSize = 48
        addChild(roundsLabel)

        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 410)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 320)) }
        for i in 0 ..< 5 { createSlot(at: CGPoint(x: 100 + (i * 170), y: 230)) }
        for i in 0 ..< 4 { createSlot(at: CGPoint(x: 180 + (i * 170), y: 140)) }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.createEnemy()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self)
        let tappedNodes = nodes(at: location)

        if tappedNodes.contains(playAgainLabel) {
            resetGame()
            return
        }

        for node in tappedNodes {
            guard let whackSlot = node.parent?.parent as? WhackSlot else { continue  }
            guard let smokeScreen = SKEmitterNode(fileNamed: "SmokeScreen") else { continue }
            if !whackSlot.isVisible { continue }
            if whackSlot.isHit { continue }
            whackSlot.hit()
            if node.name == "charFriend" {
                run(SKAction.playSoundFileNamed("whackBad.caf", waitForCompletion: false))
                score -= 5
                smokeScreen.position = whackSlot.position
                addChild(smokeScreen)
            } else if node.name == "charEnemy" {
                whackSlot.charNode.xScale = 0.85
                whackSlot.charNode.yScale = 0.85
                score += 1
                run(SKAction.playSoundFileNamed("whack.caf", waitForCompletion: false))
                smokeScreen.position = whackSlot.position
                addChild(smokeScreen)
            }
        }
    }

    private func resetGame() {
        rounds = 0
        score = 0
        gameOver.removeFromParent()
        finalScore.removeFromParent()
        playAgainLabel.removeFromParent()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            [weak self] in
            self?.createEnemy()
        }
    }

    private func createSlot(at position: CGPoint) {
        let whackSlot = WhackSlot()
        whackSlot.configure(at: position)
        addChild(whackSlot)
        slots.append(whackSlot)
    }

    private func createEnemy() {
        rounds += 1

        if rounds >= 10 {
            for slot in slots {
                slot.hide()
            }

            gameOver.position = CGPoint(x: 512, y: 384)
            gameOver.zPosition = 1

            finalScore.position = CGPoint(x: 512, y: 300)
            finalScore.zPosition = 1
            finalScore.text = "Final score: \(score)"
            finalScore.fontSize = 36

            playAgainLabel.position = CGPoint(x: 512, y: 250)
            playAgainLabel.zPosition = 1
            playAgainLabel.text = "Play Again?"
            playAgainLabel.fontSize = 36

            addChild(playAgainLabel)
            addChild(finalScore)
            addChild(gameOver)
            return
        }

        popupTime *= 0.991

        slots.shuffle()
        slots[0].show(hideTime: popupTime)

        if Int.random(in: 0...12) > 4 {
            slots[1].show(hideTime: popupTime)
        }
        if Int.random(in: 0...12) > 4 {
            slots[2].show(hideTime: popupTime)
        }
        if Int.random(in: 0...12) > 4 {
            slots[3].show(hideTime: popupTime)
        }
        if Int.random(in: 0...12) > 4 {
            slots[4].show(hideTime: popupTime)
        }

        let minDelay = popupTime / 2.0
        let maxDelay = popupTime * 2
        let delay = Double.random(in: minDelay...maxDelay)

        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            [weak self] in
            self?.createEnemy()
        }
    }
}

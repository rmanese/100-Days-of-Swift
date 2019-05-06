//
//  ViewController.swift
//  Project2
//
//  Created by Roberto Manese III on 2/27/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!

    var defaults = UserDefaults.standard

    var countries: [String] = []
    var score: Int = 0
    var correctAnswer: Int = 0
    var rounds: Int = 1
    var highScore = 0
    var shouldDisplayScore: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Show score", style: .plain, target: self, action: #selector(toggleScore))
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Round \(rounds) of 10", style: .plain, target: self, action: nil)

        highScore = defaults.integer(forKey: "highScore")

        countries += [
            "estonia", "france", "germany",
            "ireland", "italy", "monaco", "nigeria",
            "poland", "russia", "spain", "uk", "us"
        ]

        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1

        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor

        self.askQuestion()
    }

    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)

        let country = self.formatCountry(name: self.countries[correctAnswer])
        self.title = "\(country)"

        self.button1.setImage(UIImage(named: self.countries[0]), for: .normal)
        self.button2.setImage(UIImage(named: self.countries[1]), for: .normal)
        self.button3.setImage(UIImage(named: self.countries[2]), for: .normal)
    }

    @IBAction func buttonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 5, animations: {
            sender.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        })
        var title: String
        if sender.tag == correctAnswer {
            title = "Correct"
            score += 1
        } else {
            let country = self.formatCountry(name: self.countries[sender.tag])
            title = "Wrong! That's the flag of \(country)"
            score -= 1
        }
        rounds += 1

        if rounds == 10 {
            let message = generateEndGameMessage(score: score)
            let ac = UIAlertController(title: "Game Over", message: message, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Play again?", style: .default, handler: askQuestion))
            ac.addAction(UIAlertAction(title: "Quit", style: .default, handler: nil))
            self.present(ac, animated: true) {
                sender.transform = .identity
            }
            score = 0
            rounds = 1
        } else {
            let ac = UIAlertController(title: title, message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            self.present(ac, animated: true) {
                sender.transform = .identity
            }
        }

        navigationItem.rightBarButtonItem?.title = "Score: \(score)"
        navigationItem.leftBarButtonItem?.title = "Round \(rounds) of 10"
    }

    func formatCountry(name: String) -> String {
        return name.count > 2 ? name.capitalized : name.uppercased()
    }

    @objc func toggleScore() {
        shouldDisplayScore = !shouldDisplayScore

        if shouldDisplayScore {
            self.navigationItem.rightBarButtonItem?.title = "Score: \(score)"
        } else {
            self.navigationItem.rightBarButtonItem?.title = "Show Score"
        }
    }

    private func generateEndGameMessage(score: Int) -> String {
        if score > highScore {
            defaults.set(score, forKey: "highScore")
            return "Congrats you beat the high score! Your final score is \(score)"
        } else if score == highScore {
            return "Congrats you tied the high score! Your final score is \(score)"
        } else {
            return "Your final score is: \(score)"
        }
    }

}

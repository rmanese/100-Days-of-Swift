//
//  ViewController.swift
//  Challenge3
//
//  Created by Roberto Manese III on 3/14/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//
// NOTES FOR NEXT TIME:
// - letter stack view does not appear 100% of times
// - add logic to finish round
// - create heart animation
// - create alert popup for when round is complete

import UIKit

class ViewController: UIViewController {

    @IBOutlet var livesStackView: UIStackView!
    @IBOutlet var lettersStackView: UIStackView!
    @IBOutlet var wrongGuessStackView: UIStackView!
    @IBOutlet var guessWordLabel: UILabel!

    var alphabetArray = [String]()
    var wordsArray = [String]()
    var lettersButtonArray = [UIButton]()
    var usedLettersArray = [String]()
    var wrongLettersArray = [String]()
    var guessWord: String = ""
    var lives = 6

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "New Game", style: .plain, target: self, action: #selector(newGame))

        performSelector(inBackground: #selector(loadAlphabet), with: nil)
        performSelector(inBackground: #selector(loadWords), with: nil)

        layoutLivesStackView()
        layoutLetterStackView()
    }

    private func layoutWordStackView() {
        guard let word = wordsArray.shuffled().first else { return }
        print(word)
        var labelText = ""
        usedLettersArray = []
        guessWord = word
        for _ in word {
            labelText += "_ "
        }
        guessWordLabel.text = labelText
    }

    private func layoutLivesStackView() {
        livesStackView.spacing = 5
        livesStackView.distribution = .fillEqually
        for _ in 0..<6 {
            let heartImageView = UIImageView(image: UIImage(named: "heartFill"))
            heartImageView.contentMode = .scaleAspectFit
            livesStackView.addArrangedSubview(heartImageView)
        }
    }

    private func layoutLetterStackView() {
        lettersStackView.spacing = 0
        lettersStackView.axis = .vertical
        lettersStackView.distribution = .fillEqually
        
        let topRow = UIStackView()
        topRow.axis = .horizontal
        topRow.distribution = .fillEqually
        lettersStackView.addArrangedSubview(topRow)

        let midRow = UIStackView()
        midRow.axis = .horizontal
        midRow.distribution = .fillEqually
        lettersStackView.addArrangedSubview(midRow)

        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.distribution = .fillEqually
        lettersStackView.addArrangedSubview(bottomRow)

        // 0 - 12 , 13 - alphaArray.count
        for i in 0..<alphabetArray.count {
            let letterButton = UIButton(type: .system)
            letterButton.setTitle(alphabetArray[i], for: .normal)
            letterButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
            letterButton.addTarget(self, action: #selector(didTapLetterButton), for: .touchUpInside)
            lettersButtonArray.append(letterButton)

            if i < 9 {
                topRow.addArrangedSubview(letterButton)
            } else if i < 18 {
                midRow.addArrangedSubview(letterButton)
            } else {
                bottomRow.addArrangedSubview(letterButton)
            }
        }
    }

    private func emptyStackView(stackView: UIStackView) {
        for subView in stackView.subviews {
            subView.removeFromSuperview()
        }
    }

    @objc func newGame() {
        layoutWordStackView()
    }

    private func fillWord() {
        var promptWord = ""
        for letter in guessWord {
            let guess = String(letter).uppercased()
            let fill = usedLettersArray.contains(guess) ? guess : "_ "
            promptWord += fill
        }
        guessWordLabel.text = promptWord
    }

    @objc func didTapLetterButton(_ sender: UIButton) {
        guard let letter = sender.titleLabel?.text else { return }
        sender.isHidden = true
        usedLettersArray.append(letter)
        if guessWord.contains(Character(letter).lowercased()) {
            fillWord()
        } else {
            // fill wrong guess stack view, animate heart

        }
    }

    @objc func loadAlphabet() {
        if let alphabetURL = Bundle.main.url(forResource: "Letters", withExtension: "txt") {
            if let alphabet = try? String(contentsOf: alphabetURL) {
                alphabetArray = alphabet.components(separatedBy: ",")
            }
        }
    }

    @objc func loadWords() {
        if let wordsURL = Bundle.main.url(forResource: "Words", withExtension: "txt") {
            if let words = try? String(contentsOf: wordsURL) {
                wordsArray = words.components(separatedBy: "\n")
                DispatchQueue.main.async {
                    self.layoutWordStackView()
                }
            }
        }
    }

}

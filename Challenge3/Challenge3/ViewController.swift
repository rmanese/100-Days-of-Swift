//
//  ViewController.swift
//  Challenge3
//
//  Created by Roberto Manese III on 3/14/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var livesStackView: UIStackView!
    @IBOutlet var lettersStackView: UIStackView!

    var alphabetArray = [String]()
    var lettersButtonArray = [UIButton]()

    override func viewDidLoad() {
        super.viewDidLoad()

        performSelector(inBackground: #selector(loadAlphabet), with: nil)

        layoutLivesStackView()
        layoutLetterStackView()
    }

    private func layoutLivesStackView() {
        for _ in 0..<6 {
            let heartImageView = UIImageView(image: UIImage(named: "heart"))
            livesStackView.addArrangedSubview(heartImageView)
        }

        livesStackView.spacing = 10
        livesStackView.distribution = .fillEqually
    }

    private func layoutLetterStackView() {
        let topRow = UIStackView()
        topRow.axis = .horizontal
        topRow.distribution = .fillEqually
        topRow.spacing = 3
        lettersStackView.addArrangedSubview(topRow)

        let midRow = UIStackView()
        midRow.axis = .horizontal
        midRow.distribution = .fillEqually
        midRow.spacing = 3
        lettersStackView.addArrangedSubview(midRow)

        let bottomRow = UIStackView()
        bottomRow.axis = .horizontal
        bottomRow.distribution = .fillEqually
        bottomRow.spacing = 3
        lettersStackView.addArrangedSubview(bottomRow)

        // 0 - 12 , 13 - alphaArray.count
        for i in 0..<alphabetArray.count {
            let letterButton = UIButton(type: .system)
            letterButton.setTitle(alphabetArray[i], for: .normal)
            letterButton.addTarget(self, action: #selector(didTapLetterButton), for: .touchUpInside)
            lettersButtonArray.append(letterButton)

            if i < 9 {
                topRow.addArrangedSubview(letterButton)
            } else if i < 18 {
                midRow.addArrangedSubview(letterButton)
            }else {
                bottomRow.addArrangedSubview(letterButton)
            }
        }

        lettersStackView.spacing = 10
        lettersStackView.distribution = .fillEqually
    }

    @objc func didTapLetterButton() {

    }

    @objc func loadAlphabet() {
        if let alphabetURL = Bundle.main.url(forResource: "Letters", withExtension: "txt") {
            if let alphabet = try? String(contentsOf: alphabetURL) {
                alphabetArray = alphabet.components(separatedBy: ",")
            }
        }
    }

    

}

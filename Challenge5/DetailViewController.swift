//
//  DetailViewController.swift
//  Challenge5
//
//  Created by Roberto Manese III on 5/6/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var stackView: UIStackView!

    var state: State?

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let state = state else { return }
        title = state.name

        loadDetails()
    }

    private func loadDetails() {
        guard let state = state else { return }
        let name = UILabel()
        name.text = "Name: \(state.name)"
        let abbreviation = UILabel()
        abbreviation.text = "Abbreviation: \(state.abbreviation)"
        let capital = UILabel()
        capital.text = "Capital: \(state.capital)"
        let population = UILabel()
        population.text = "Population: \(state.population)"
        let size = UILabel()
        size.text = "Size: \(state.size) mi^2"
        let notes = UILabel()
        notes.text = "Notes: \(state.notes)"
        notes.numberOfLines = 0

        stackView.addArrangedSubview(name)
        stackView.addArrangedSubview(abbreviation)
        stackView.addArrangedSubview(capital)
        stackView.addArrangedSubview(population)
        stackView.addArrangedSubview(size)
        stackView.addArrangedSubview(notes)
    }

}

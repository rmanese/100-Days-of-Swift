//
//  ViewController.swift
//  Project6
//
//  Created by Roberto Manese III on 3/5/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var petitions = [Petition]()
    var filteredPetitions = [Petition]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Credit", style: .plain, target: self, action: #selector(didTapCredit))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Filter", style: .plain, target: self, action: #selector(didTapFilter))

        let urlString: String
        if self.navigationController?.tabBarItem.tag == 0 {
            urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        }

        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                self.parse(json: data)
                return
            }
        }

        showError()
    }

    @objc func didTapFilter() {
        let ac = UIAlertController(title: "Search Petitions by words", message: nil, preferredStyle: .alert)
        ac.addTextField { (textField) in
            textField.placeholder = "Search"
        }
        ac.addAction(UIAlertAction(title: "Submit", style: .default, handler: { (action) in
            self.filteredPetitions = []
            let searchTerm = ac.textFields?[0].text ?? ""
            for item in self.petitions {
                if item.title.contains(searchTerm) {
                    self.filteredPetitions.append(item)
                }
            }

            self.tableView.reloadData()
        }))
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (action) in
            self.filteredPetitions = self.petitions
            self.tableView.reloadData()
        }))
        self.present(ac, animated: true)
    }

    @objc func didTapCredit() {
        let ac = UIAlertController(title: "Brought to you by: WeThePeople API", message: nil, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }

    func showError() {
        let ac = UIAlertController(title: "Loading Error", message: "There was a problem loading the feed. Check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        self.present(ac, animated: true)
    }

    func parse(json: Data) {
        let decoder = JSONDecoder()
        if let jsonPetitions = try? decoder.decode(Petitions.self, from: json) {
            self.petitions = jsonPetitions.results
            self.filteredPetitions = jsonPetitions.results
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.filteredPetitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = self.filteredPetitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = self.filteredPetitions[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
    }

}


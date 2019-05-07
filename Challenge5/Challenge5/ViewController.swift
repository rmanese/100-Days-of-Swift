//
//  ViewController.swift
//  Challenge5
//
//  Created by Roberto Manese III on 5/6/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    private var states = [State]()

    let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self

        tableView.frame = view.frame

        view.addSubview(tableView)

        fetchStates { (states, error) in
            self.states = states
        }
    }

    func fetchStates(completionHandler: @escaping (([State], Error?) -> Void)) {
        if let url = Bundle.main.url(forResource: "States", withExtension: "json") {
            do {
                let jsonDecoder = JSONDecoder()
                let jsonData = try Data(contentsOf: url)
                let json = try jsonDecoder.decode([State].self, from: jsonData)
                completionHandler(json, nil)
            } catch {
                print(error)
            }
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return states.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = states[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let state = states[indexPath.row]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.state = state
            navigationController?.pushViewController(vc, animated: true)
        }
    }

}


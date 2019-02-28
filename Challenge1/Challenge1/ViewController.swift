//
//  ViewController.swift
//  Challenge1
//
//  Created by Roberto Manese III on 2/27/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var countries: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.countries += [
            "estonia", "france", "germany",
            "ireland", "italy", "monaco",
            "nigeria", "poland", "russia",
            "spain", "us", "uk"
        ]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.countries.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Country", for: indexPath)
        cell.textLabel?.text = self.formatCountry(name: self.countries[indexPath.row])
        cell.imageView?.image = UIImage(named: self.countries[indexPath.row])
        cell.imageView?.layer.borderWidth = 1
        cell.imageView?.layer.borderColor = UIColor.black.cgColor
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            vc.selectedFlag = self.countries[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func formatCountry(name: String) -> String {
        return name.count > 2 ? name.capitalized : name.uppercased()
    }
}

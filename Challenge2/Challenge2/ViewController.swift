//
//  ViewController.swift
//  Challenge2
//
//  Created by Roberto Manese III on 3/4/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    var shoppingList: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .trash, target: self, action: #selector(didTapClearCart))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapAddItem))
    }


    @objc func didTapClearCart() {
        self.shoppingList = []
        self.tableView.reloadData()
    }

    @objc func didTapAddItem() {
        let ac = UIAlertController(title: "Add Item", message: nil, preferredStyle: .alert)
        ac.addTextField()
        ac.addAction(UIAlertAction(title: "Add", style: .default, handler: { (_) in
            guard let text = ac.textFields?[0].text else {
                return
            }
            let indexPath = IndexPath(row: self.shoppingList.count, section: 0)
            self.shoppingList.append(text)
            self.tableView.insertRows(at: [indexPath], with: .automatic)
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(ac, animated: true)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.shoppingList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item", for: indexPath)
        cell.textLabel?.text = self.shoppingList[indexPath.row]
        return cell
    }

}


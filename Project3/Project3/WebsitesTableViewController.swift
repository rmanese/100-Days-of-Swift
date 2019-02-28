//
//  WebsitesTableViewController.swift
//  Project3
//
//  Created by Roberto Manese III on 2/28/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class WebsitesTableViewController: UITableViewController {

    var websites: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        if let websiteURLs = Bundle.main.url(forResource: "Website", withExtension: "txt") {
            if let websites = try? String(contentsOf: websiteURLs) {
                self.websites = websites.components(separatedBy: "\n")
            }
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.websites.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "website", for: indexPath)
        cell.textLabel?.text = self.websites[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let vc = storyboard?.instantiateViewController(withIdentifier: "webview") as? ViewController {
            vc.website = self.websites[indexPath.row]
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

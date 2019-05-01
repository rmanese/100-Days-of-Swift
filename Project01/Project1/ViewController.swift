//
//  ViewController.swift
//  Project1
//
//  Created by Roberto Manese III on 2/27/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {

    let defaults = UserDefaults.standard

    var pictures: [String] = []
    static var totalPictures: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Storm Viewer"
        self.navigationController?.navigationBar.prefersLargeTitles = true

        performSelector(inBackground: #selector(loadImages), with: nil)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    @objc func loadImages() {
        let fm = FileManager.default
        let path = Bundle.main.resourcePath!
        let items = try! fm.contentsOfDirectory(atPath: path)

        for item in items {
            if item.hasPrefix("nssl") {
                self.pictures.append(item)
            }
        }
        self.pictures = self.pictures.sorted()
        ViewController.totalPictures = self.pictures.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.pictures.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let image = pictures[indexPath.row]
        let timesViewed = defaults.integer(forKey: image)
        let cell = tableView.dequeueReusableCell(withIdentifier: "Picture", for: indexPath)
        cell.textLabel?.text = image
        cell.detailTextLabel?.text = "Viewed \(timesViewed) times"
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController {
            let image = pictures[indexPath.row]
            updateViewCount(image: image)
            vc.selectedImage = image
            vc.imageNumber = indexPath.row + 1
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }

    func updateViewCount(image: String) {
        var timesViewed = defaults.integer(forKey: image)
        timesViewed += 1
        defaults.set(timesViewed, forKey: image)
    }

}


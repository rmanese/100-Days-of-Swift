//
//  DetailViewController.swift
//  Challenge1
//
//  Created by Roberto Manese III on 2/27/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    var selectedFlag: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

        if let flagToLoad = selectedFlag {
            self.imageView.image = UIImage(named: flagToLoad)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.hidesBarsOnTap = true
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.hidesBarsOnTap = false
        self.imageView.image = nil
    }

    @objc func shareTapped() {

        guard let image = imageView.image?.pngData(),
            let countryName = selectedFlag else {
                print("No image found")
                return
        }

        let vc = UIActivityViewController(activityItems: [image, countryName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        self.present(vc, animated: true)
    }


}

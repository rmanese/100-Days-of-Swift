//
//  DetailViewController.swift
//  Project1
//
//  Created by Roberto Manese III on 2/27/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!

    var selectedImage: String?
    var imageNumber: Int?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Picture \(imageNumber ?? 0) of \(ViewController.totalPictures)"
        self.navigationItem.largeTitleDisplayMode = .never

        if let imageToLoad = selectedImage {
            imageView.image = UIImage(named: imageToLoad)
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

}

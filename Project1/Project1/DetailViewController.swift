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

        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(shareTapped))

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

    @objc func shareTapped() {
        guard let image = imageView.image?.jpegData(compressionQuality: 0.8) else {
            print("No image found")
            return
        }
        guard let imageName = selectedImage else {
            return
        }

        let vc = UIActivityViewController(activityItems: [image, imageName], applicationActivities: [])
        vc.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        self.present(vc, animated: true)
    }

}

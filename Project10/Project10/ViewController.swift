//
//  ViewController.swift
//  Project10
//
//  Created by Roberto Manese III on 4/30/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var intensity: UISlider!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var changeFilterButton: UIButton!

    var currentImage: UIImage!

    var context: CIContext!
    var currentFilter: CIFilter!

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Instafilter"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importImage))

        changeFilterButton.addTarget(self, action: #selector(didChangeFilter), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(didTapSave), for: .touchUpInside)

        configureButton(button: changeFilterButton)
        configureButton(button: saveButton)

        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        currentImage = image
        dismiss(animated: true)

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }

    @objc func importImage() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }

    @objc func didChangeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))

        if let popoverConroller = ac.popoverPresentationController {
            popoverConroller.sourceView = sender
            popoverConroller.sourceRect = sender.bounds
        }

        present(ac, animated: true)
    }

    private func setFilter(action: UIAlertAction) {
        guard currentImage != nil else {
            let ac = UIAlertController(title: "No image selected", message: "Choose an image from your photo library", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Dismiss", style: .cancel))
            present(ac, animated: true)
            return
        }
        guard let title = action.title else { return }
        currentFilter = CIFilter(name: title)

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)

        applyProcessing()
    }

    @objc func didTapSave() {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "No image to save", message: "Choose an image from your photo library", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            return
        }
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @IBAction func intensityChanged(_ sender: Any) {
        applyProcessing()
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save Error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your edits have been saved", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .cancel))
            present(ac, animated: true)
        }
    }

    private func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) {
            currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        }
        if inputKeys.contains(kCIInputRadiusKey) {
            currentFilter.setValue(intensity.value * 200, forKey: kCIInputRadiusKey)
        }
        if inputKeys.contains(kCIInputScaleKey) {
            currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey)
        }
        if inputKeys.contains(kCIInputCenterKey) {
            currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey)
        }

        guard let outputImage = currentFilter.outputImage else { return }

        if let cgImg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImg)
            imageView.image = processedImage
        }
    }

    private func configureButton(button: UIButton) {
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.layer.cornerRadius = 10
        button.tintColor = .white
    }

}


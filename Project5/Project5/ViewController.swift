//
//  ViewController.swift
//  Project5
//
//  Created by Roberto Manese III on 3/4/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let label1 = UILabel()
        label1.translatesAutoresizingMaskIntoConstraints = false
        label1.backgroundColor = .yellow
        label1.text = "ONE"
        label1.sizeToFit()

        let label2 = UILabel()
        label2.translatesAutoresizingMaskIntoConstraints = false
        label2.backgroundColor = .green
        label2.text = "TWO"
        label2.sizeToFit()


        let label3 = UILabel()
        label3.translatesAutoresizingMaskIntoConstraints = false
        label3.backgroundColor = .red
        label3.text = "THREEEEEE"
        label3.sizeToFit()


        let label4 = UILabel()
        label4.translatesAutoresizingMaskIntoConstraints = false
        label4.backgroundColor = .orange
        label4.text = "FOURRRRRRRRRRR"
        label4.sizeToFit()


        let label5 = UILabel()
        label5.translatesAutoresizingMaskIntoConstraints = false
        label5.backgroundColor = .blue
        label5.text = "FIVEEEEEEEEEEEEEE"
        label5.sizeToFit()

        view.addSubview(label1)
        view.addSubview(label2)
        view.addSubview(label3)
        view.addSubview(label4)
        view.addSubview(label5)
//
//        let viewsDictionary = ["label1": label1,
//                               "label2": label2,
//                               "label3": label3,
//                               "label4": label4,
//                               "label5": label5]
//
//        let metrics = ["labelHeight": 88]
//
//        for label in [label1, label2, label3, label4, label5] {
//            view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[\(key)]|", options: [], metrics: nil, views: viewsDictionary))
//        }
//
//        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[label1(labelHeight@999)]-[label2(label1)]-[label3(label1)]-[label4(label1)]-[label5(label1)]-(>=10)-|", options: [], metrics: metrics, views: viewsDictionary))

        var previous: UILabel?

        for label in [label1, label2, label3, label4, label5] {

            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
            label.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2, constant: 0).isActive = true

            if let previous = previous {
                label.topAnchor.constraint(equalTo: previous.bottomAnchor, constant: 10).isActive = true
            } else {
                label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            }

            previous = label
        }
    }


}


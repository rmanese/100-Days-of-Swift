//
//  PostCell.swift
//  Challenge4
//
//  Created by Roberto Manese III on 4/29/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    @IBOutlet var postImage: UIImageView!
    @IBOutlet var captionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        postImage.layer.borderColor = UIColor(white: 0, alpha: 0.3).cgColor
        postImage.layer.borderWidth = 2
        postImage.layer.cornerRadius = 3
    }
    
}

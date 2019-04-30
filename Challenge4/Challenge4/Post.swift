//
//  Post.swift
//  Challenge4
//
//  Created by Roberto Manese III on 4/29/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import Foundation

class Post: Codable {
    var imageName: String
    var caption: String

    init(name: String, caption: String) {
        self.imageName = name
        self.caption = caption
    }
}

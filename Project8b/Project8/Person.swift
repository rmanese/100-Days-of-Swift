//
//  Person.swift
//  Project8
//
//  Created by Roberto Manese III on 4/2/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class Person: NSObject, Codable {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}

//
//  Person.swift
//  Project8
//
//  Created by Roberto Manese III on 4/2/19.
//  Copyright © 2019 jawnyawn. All rights reserved.
//

import UIKit

class Person: NSObject, NSCoding {
    var name: String
    var image: String

    init(name: String, image: String) {
        self.name = name
        self.image = image
    }

    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String ?? ""
        image = aDecoder.decodeObject(forKey: "image") as? String ?? ""
    }

    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(image, forKey: "iamge")
    }

}

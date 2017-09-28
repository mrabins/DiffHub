//
//  Pull.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/26/17.
//  Copyright © 2017 self. All rights reserved.
//

import Foundation

struct Pull {
    var avatarImage: String?
    var author: String?
    var pullTitle: String?
    var diffUrl: String?

    init(avatarImage: String, author: String, pullTitle: String, diffUrl: String) {
        self.avatarImage = avatarImage
        self.author = author
        self.pullTitle = pullTitle
        self.diffUrl = diffUrl
    }
}





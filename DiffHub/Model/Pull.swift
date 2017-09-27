//
//  Pull.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/26/17.
//  Copyright © 2017 self. All rights reserved.
//

import Foundation

struct Pull: Codable {
    var avatarImage: String?
    var author: String?
    var pullTitle: String?
    var pullDetails: String?
    var id: Int?
    var diffUrl: String?
    
    
    init(avatarImage: String, author: String, pullTitle: String, pullDetails: String, id: Int, diffUrl: String) {
        self.avatarImage = avatarImage
        self.author = author
        self.pullTitle = pullTitle
        self.pullDetails = pullDetails
        self.id = id
        self.diffUrl = diffUrl
    }
}

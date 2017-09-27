//
//  RequestConstants.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/26/17.
//  Copyright © 2017 self. All rights reserved.
//

import Foundation

struct RequestConstants {
    
    static var githubAPI = "https://api.github.com"
    static var repo = "repos"
    static var owner = "magicalpanda"
    static var repoName = "MagicalRecord"
    static var requesType = "pulls"

    static var pullURL = RequestConstants.githubAPI + "/" + RequestConstants.repo + "/" + RequestConstants.owner + "/" + RequestConstants.repoName + "/" + RequestConstants.requesType
}



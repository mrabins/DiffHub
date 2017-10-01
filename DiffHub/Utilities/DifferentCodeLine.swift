//
//  DifferentCodeLine.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/28/17.
//  Copyright © 2017 self. All rights reserved.
//

import Foundation

class DifferentCodeLine {
    
    enum CodeLineType {
        case plusOrMinus
        case common
        case title
    }
    
    var type = CodeLineType.common
    
    var leftContent = String()
    var leftNum = Int()
    var leftStartNum = Int()
    
    var rightContent = String()
    var rightNum = Int()
    var rightStartNum = Int()
    
    var sharedContent = String()
    
    var isLeftNull = false
    var isRightNull = false
    
}

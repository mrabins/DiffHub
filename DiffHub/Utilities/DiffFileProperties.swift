//
//  DiffFileProperties.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/28/17.
//  Copyright © 2017 self. All rights reserved.
//

import Foundation

class DiffFile {
    
    var startIndex = Int()
    var endIndex = Int()
    var title = String()
    var pullRequestId = Int()
    var mode = String()
    var sourceFileA = String()
    var sourceFileB = String()
    
    var sections = Array<FileSection>()
    var lines = Array<String>()
    var codeLines = Array<DifferentCodeLine>()
    
    func parseSource(sourceStr: String) -> String {
        let sourceStr = sourceStr as NSString
        return sourceStr.substring(with: NSRange(location: self.startIndex, length: self.endIndex))
    }
    
}

class FileSection {
    
    var startIndex = Int()
    var endIndex = Int()
    
    var title = String()
    var lines = Int()
    var sectionSource = Array<String>()
    
    func parseSource(sourceStr: String) -> String {
        let sourceStr = sourceStr as NSString
        return sourceStr.substring(with: NSRange(location: self.startIndex, length: self.endIndex))
    }
    
}

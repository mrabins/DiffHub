//
//  DifferentCodeBlock.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/28/17.
//  Copyright © 2017 self. All rights reserved.
//

import Foundation

class DifferentCodeBlock {
    
    var minorNum = Int()
    var plusNum = Int()
    
    var blockArray = Array<String>()
    
    var blockMinor : Array<String>?
    var blockPlus : Array<String>?
    
    func append(line: String) {
        let firstChar = line.characters.first
        if firstChar == "+" {
            self.plusNum += 1
        }
        else if firstChar == "-" {
            self.minorNum += 1
        }
        self.blockArray.append(line)
    }
    
    func generateBlocks() {
        
        self.blockMinor = Array<String>()
        self.blockPlus = Array<String>()
        
        let diffNum = minorNum - plusNum
        
        for str in blockArray {
            if str.characters.first == "-" {
                self.blockMinor?.append(str)
            }
            else if str.characters.first == "+" {
                self.blockPlus?.append(str)
            }
        }
        
        
        //using "$" to represent placeholder line
        if diffNum > 0 {
            //more minor
            for _ in 0..<diffNum {
                self.blockPlus?.append("$")
            }
            
        }
        else if diffNum < 0 {
            //more plus
            let diffNum = diffNum * -1
            for _ in 0..<diffNum {
                self.blockMinor?.append("$")
            }
            
        }
        else {
            //equal - arrays are ready
        }
        
    }
    
}

//
//  DiffVC.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/28/17.
//  Copyright © 2017 self. All rights reserved.
//

import UIKit

class DiffVC: UIViewController {
    
    var pull: Pull!
    let currentOrientation = UIApplication.shared.statusBarOrientation
    var previousOrientation = Int()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setOrientation()
        
    }
    
    func setOrientation() {
        
        if currentOrientation.isPortrait {
            UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        }
    }
    override func viewDidDisappear(_ animated: Bool) {
        if previousOrientation == 1 {
            UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")

                
        }
    }
}

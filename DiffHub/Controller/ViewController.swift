//
//  ViewController.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/25/17.
//  Copyright © 2017 self. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIHandler.callAPI({ (pull) in
            
        }) { (errorMessage) in
            print("An error occured \(errorMessage.debugDescription)")}
    }
    
    }





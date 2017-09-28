//
//  PullCell.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/26/17.
//  Copyright © 2017 self. All rights reserved.
//

import UIKit

class PullCell: UITableViewCell {
    
    
    //MARK: IBOutlets
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var pullTextView: UITextView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layoutIfNeeded()
        self.avatarImageView.layer.cornerRadius = 12.0
        self.avatarImageView.clipsToBounds = true
    }
}

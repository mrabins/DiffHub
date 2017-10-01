//
//  CodeLineTableViewCell.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/28/17.
//  Copyright © 2017 self. All rights reserved.
//

import UIKit

class CodeLineTableViewCell: UITableViewCell {

    @IBOutlet weak var leftLineNumLabel: UILabel!
    @IBOutlet weak var leftCodeLabel: UILabel!
    
    @IBOutlet weak var rightLineNumLabel: UILabel!
    @IBOutlet weak var rightCodeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }

}

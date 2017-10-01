//
//  SectionTitleTableViewCell.swift
//  DiffHub
//
//  Created by Mark Rabins on 9/29/17.
//  Copyright © 2017 self. All rights reserved.
//

import UIKit

class DiffFileTableViewHeaderViewCell: UITableViewCell {
    
    @IBOutlet weak var sectionTitleLabel: UILabel!
    @IBOutlet weak var leftPaddingView: UIView!
    
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


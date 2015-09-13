//
//  DvdCell.swift
//  Rotten Tomatoes
//
//  Created by Tianyi Xing on 9/13/15.
//  Copyright © 2015 Tianyi Xing. All rights reserved.
//

import UIKit

class DvdCell: UITableViewCell {
    
 
    @IBOutlet weak var posterView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
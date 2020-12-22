//
//  MoodSelectionUPLDTableViewCell.swift
//  Aura
//
//  Created by Apple on 19/11/15.
//  Copyright © 2015 necixy. All rights reserved.
//

import UIKit

class MoodSelectionUPLDTableViewCell: UITableViewCell {
    @IBOutlet var imgSelection: UIImageView!

    @IBOutlet var lblMoodName: UILabel!
    @IBOutlet var imgMood: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

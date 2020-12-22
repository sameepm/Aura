//
//  TrackMoodsTableViewCell.swift
//  Aura
//
//  Created by necixy on 30/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class TrackMoodsTableViewCell: UITableViewCell {
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var imgUser: UIImageView!

    @IBOutlet weak var imgMood: UIImageView!
    @IBOutlet weak var lblMood: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

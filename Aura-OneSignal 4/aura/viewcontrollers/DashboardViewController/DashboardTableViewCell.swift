//
//  DashboardTableViewCell.swift
//  Aura
//
//  Created by Apple on 25/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class DashboardTableViewCell: UITableViewCell {
    @IBOutlet weak var imgUser: UIImageView!
    
    @IBOutlet var icon: UIImageView!
    @IBOutlet weak var imgOther: UIImageView!
    @IBOutlet weak var lblTime: UILabel!
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

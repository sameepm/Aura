//
//  LeftmenuCell.swift
//  Aura
//
//  Created by necixy on 07/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class LeftmenuCell: UITableViewCell {
    
    @IBOutlet weak var btnSetting: UIButton!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userImg: UIImageView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

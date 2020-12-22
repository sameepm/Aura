//
//  FriendReqCell.swift
//  Aura
//
//  Created by necixy on 28/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class FriendReqCell: UITableViewCell {

    @IBOutlet weak var btnReject: UIButton!
    @IBOutlet weak var btnAccept: UIButton!
    @IBOutlet weak var lbluserName: UILabel!
    @IBOutlet weak var imgUser: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

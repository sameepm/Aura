//
//  MMTableCell.swift
//  Aura
//
//  Created by necixy on 16/10/15.
//  Copyright (c) 2015 necixy. All rights reserved.
// $ openssl x509 -inform der -in aps_development.cer -out certificate.pem


import UIKit

class MMTableCell: UITableViewCell {
    @IBOutlet weak var lblReadData: UILabel!

    @IBOutlet var icon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

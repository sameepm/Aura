//
//  MoodsCollectionViewCell.swift
//  Aura
//
//  Created by necixy on 21/09/15.
//  Copyright (c) 2015 necixy. All rights reserved.
//

import UIKit

class MoodsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imgMood: UIImageView!

    @IBOutlet weak var lblMoodTxt: UILabel!
    @IBOutlet weak var btnNext: UIButton!
    @IBOutlet weak var imgTransparent: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}

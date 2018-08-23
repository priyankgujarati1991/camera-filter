//
//  CustomCell.swift
//  CameraFilter
//
//  Created by Tosc189 on 23/08/18.
//  Copyright © 2018 Tosc189. All rights reserved.
//

import UIKit

class CustomCell: UITableViewCell {

    @IBOutlet var imgThumb: UIImageView!
    @IBOutlet var viewVideo: UIView!
    @IBOutlet var mainView: UIView!
    @IBOutlet var lblTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

//
//  BigButtonTableViewCell.swift
//  undeadbread
//
//  Created by stephenciauri on 2/17/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit

class BigButtonTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        textLabel?.layer.cornerRadius = 5
        layer.borderWidth = 0
    }
}

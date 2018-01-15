//
//  TextFieldTableViewCell.swift
//  undeadbread
//
//  Created by stephenciauri on 1/14/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit

class TextFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

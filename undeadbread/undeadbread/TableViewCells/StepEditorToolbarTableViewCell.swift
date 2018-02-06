//
//  StepEditorToolbarTableViewCell.swift
//  undeadbread
//
//  Created by stephenciauri on 2/5/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit

protocol StepEditorToolbarTableViewCellDelegate: class {
    func composeButtonPressed(in cell: UITableViewCell)
    func cameraButtonPressed(in cell: UITableViewCell)
}

class StepEditorToolbarTableViewCell: UITableViewCell {
    weak var delegate: StepEditorToolbarTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func composeButtonPressed() {
        delegate?.composeButtonPressed(in: self)
    }
    
    @IBAction func cameraButtonPressed() {
        delegate?.cameraButtonPressed(in: self)
    }

}

//
//  TextFieldTableViewCell.swift
//  undeadbread
//
//  Created by stephenciauri on 1/14/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit

protocol TextFieldTableViewCellDelegate: class {
    func textFieldDidChange(text: String, in cell: UITableViewCell)
}
class TextFieldTableViewCell: UITableViewCell {
    @IBOutlet weak var textField: UITextField!
    weak var delegate: TextFieldTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

extension TextFieldTableViewCell: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let newString = (text as NSString).replacingCharacters(in: range, with: string as String)
            delegate?.textFieldDidChange(text: newString, in: self)
        }
        
        return true
    }
}

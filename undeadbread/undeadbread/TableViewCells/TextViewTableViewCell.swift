//
//  TextViewTableViewCell.swift
//  undeadbread
//
//  Created by stephenciauri on 2/1/18.
//  Copyright © 2018 Stephen Ciauri. All rights reserved.
//

import UIKit

protocol TextViewTableViewCellDelegate: class {
    func textViewHeightDidChange(in cell: UITableViewCell)
    func textViewDidChange(textView: UITextView, in cell: UITableViewCell)
}

class TextViewTableViewCell: UITableViewCell {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var numberingLabel: UILabel!
    
    weak var delegate: TextViewTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }


    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

extension TextViewTableViewCell: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        delegate?.textViewDidChange(textView: textView, in: self)
        let startHeight = textView.frame.size.height
        let calcHeight = textView.sizeThatFits(textView.frame.size).height
        if startHeight != calcHeight {
            delegate?.textViewHeightDidChange(in: self)
        }
    }
}

//
//  TextFieldView.swift
//  LongTester
//
//  Created by Long on 4/17/23.
//

import Foundation
import UIKit

class TextFieldView : UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textFieldView: UITextField!
    @IBOutlet weak var separatorView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit(){
        loadViewFromNib()
        textFieldView.delegate = self
    }
    
    func setup(text : String, color: UIColor = Color.greyPrimary) {
        titleLbl.text = text
        separatorView.backgroundColor = color
    }
}

extension TextFieldView : UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textFieldView.resignFirstResponder()
    }
}

extension UITextField {
    public override func resignFirstResponder() -> Bool {
        return super.resignFirstResponder()
    }
}

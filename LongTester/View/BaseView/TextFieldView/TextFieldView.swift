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
    
    private func commonInit(){
        loadViewFromNib()
        titleLbl.isHidden = true
        setup()
        textFieldView.delegate = self
    }
    
    private func changePlaceholder(disable: Bool){
        titleLbl.isHidden = disable
        textFieldView.placeholder = disable ?  titleLbl.text : ""
    }
}

///FUNCTION ACCESSABLE
extension TextFieldView {
    func setup(text : String = "Label", color: UIColor = Color.greyPrimary, isSecure: Bool = false) {
        titleLbl.text = text
        textFieldView.attributedPlaceholder = NSAttributedString(
            string: titleLbl.text ?? "",
            attributes: [NSAttributedString.Key.foregroundColor: Color.greyPrimary]
        )
        textFieldView.isSecureTextEntry = isSecure
        separatorView.backgroundColor = color
    }
    
    func getData() -> String {
        return textFieldView.text ?? ""
    }
    
    func addDefaultData(defaultValue: String) {
        textFieldView.text = defaultValue
        if (textFieldView.text == "") {
            changePlaceholder(disable: true)
        }
        else {
            changePlaceholder(disable: false)
        }
    }
    
    
}
extension TextFieldView : UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textFieldView.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        changePlaceholder(disable: false)
        
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text == "") {
            changePlaceholder(disable: true)
        }
        else {
            changePlaceholder(disable: false)
        }
    }
}

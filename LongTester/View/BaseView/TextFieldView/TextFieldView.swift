//
//  TextFieldView.swift
//  LongTester
//
//  Created by Long on 4/17/23.
//

import Foundation
import UIKit
protocol TextFieldViewDelegate : AnyObject {
    func handleErrorMessage(text: String)
}
class TextFieldView : UIView {
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var textFieldView: UITextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var invalidView: UIView!
    
    weak var delegate : TextFieldViewDelegate?
    var isCompulsory : Bool = false
    var colorTheme : UIColor = Color.greyPrimary
    private var errorMessage = ""
    private var validations : [ValidationModel]?
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
    
    private func changeColorBaseOnValidation(validated: Bool) {
        
        let color = validated ? colorTheme : Color.redPrimary
        
        invalidView.isHidden = validated
        errorMessage = validated ? "" : errorMessage
        textFieldView.attributedPlaceholder = NSAttributedString(
            string: (titleLbl.text ?? ""),
            attributes: [NSAttributedString.Key.foregroundColor: color]
        )
        
        titleLbl.textColor = color
    }
    
    @IBAction func invalidBtnPressed(_ sender: Any) {
        self.delegate?.handleErrorMessage(text: errorMessage)
    }
}

///FUNCTION ACCESSABLE
extension TextFieldView {
    func setup(text : String = "Label", color: UIColor = Color.greyPrimary, isSecure: Bool = false, isCompulsory : Bool = false) {
        titleLbl.text = text + (isCompulsory ? "(*)" : "")
        self.isCompulsory = isCompulsory
        self.colorTheme = color
        
        changeColorBaseOnValidation(validated: true)
        
        textFieldView.isSecureTextEntry = isSecure
        separatorView.backgroundColor = colorTheme
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
    
    func addValidation(validation : [ValidationModel]?) {
        self.validations = validation
    }
    func checkValidation() ->Bool{
        if (isCompulsory && textFieldView.text == ""){
            changeColorBaseOnValidation(validated: false)
            errorMessage = Language.localized("isRequired")
            return false
        }
        if let validations = validations {
            var isHasError: Bool = false
            for validation in validations {
                let regex = validation.regex
                let message = validation.errorMessage
                let text = textFieldView.text ?? ""
                if !regex.isEmpty, !text.matches(pattern: regex) {
                    errorMessage += message + ", "
                    isHasError = true
                }
            }
            if isHasError {
                changeColorBaseOnValidation(validated: false)
                return false
            }
            else {
                return true
            }
        }else {
            return true
        }
    }
}
extension TextFieldView : UITextFieldDelegate {
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        textFieldView.resignFirstResponder()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        changeColorBaseOnValidation(validated: true)
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

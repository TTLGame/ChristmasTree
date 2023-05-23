//
//  DateSelectView.swift
//  LongTester
//
//  Created by Long on 5/22/23.
//

import Foundation
import UIKit
import SnapKit

class DateSelectView : UIView {
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
      
        
        datePicker.setDate(Date(), animated: true)
        datePicker.addTarget(self, action: #selector(didScrollValueDate), for: .valueChanged)
        return datePicker
    }()
    var labelTextField = UITextField()
    var formatDate : String = App.Format.headerDateTime
    var dateHeight : CGFloat = 420
    var visibleTextField  = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    func commonInit(){
//        loadViewFromNib()
        setupDate()
    }
    @objc func didScrollValueDate() {
        let formatter = DateFormatter()
        formatter.dateFormat = self.formatDate
        let selectedDate = formatter.string(from: datePicker.date)
        print("selected date :\(selectedDate)")
    }
    
    func setupDate(height : CGFloat = 420){
        self.dateHeight = height
        
        let labelTextField = UITextField()
        self.addSubview(labelTextField)
        labelTextField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.labelTextField = labelTextField
        
        // Big enough frame
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: self.dateHeight)
        let pickerWrapperView = UIView(frame: rect)
        pickerWrapperView.addSubview(datePicker)

        // Adding constraints
        datePicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        // Using wrapper view instead of picker
        labelTextField.inputView = pickerWrapperView
        configureUI()
    }
    
    private func configureUI() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: Language.localized("doneBtn"),
                                         style: .done,
                                         target: self,
                                         action: #selector(handleDoneButton(_:)))
        
        let cancelButton = UIBarButtonItem(title: Language.localized("cancelBtn"),
                                         style: .done,
                                         target: self,
                                         action: #selector(handleCancelButton(_:)))
        
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        toolbar.setItems([cancelButton, space, doneButton], animated: true)
        toolbar.tintColor = Color.normalTextColor
        labelTextField.inputAccessoryView = toolbar
    }
    
    @objc func handleDoneButton(_ textField: UITextField) {
        let formatter = DateFormatter()
        formatter.dateFormat = App.Format.responseTime
        let selectedDate = formatter.string(from: datePicker.date)
        print("Done \(selectedDate)")
        labelTextField.endEditing(true)
    }
    
    @objc func handleCancelButton(_ textField: UITextField) {
        labelTextField.endEditing(true)
    }
}

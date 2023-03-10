//
//  ViewController.swift
//  LongTester
//
//  Created by Long on 12/28/22.
//

import UIKit

class MainScreenViewController: UIViewController {

    @IBOutlet weak var languageSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var labelTextField: UITextField!
    
    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
      
        
        datePicker.setDate(Date(), animated: true)
        datePicker.addTarget(self, action: #selector(setTitle), for: .valueChanged)
        return datePicker
    }()
    
    @objc func setTitle() {
        let formatter = DateFormatter()
        formatter.dateFormat = App.Format.headerDateTime
        let selectedDate = formatter.string(from: datePicker.date)
        labelTextField.text = selectedDate
        // Update data if date picker has been change
        formatter.dateFormat = App.Format.responseTime
        let serverDate = formatter.string(from: datePicker.date)
//        viewModel?.set(input: serverDate)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDate()
        setupSwitch()
        // Do any additional setup after loading the view.
    }
 
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
   
    private func setupSwitch(){
        self.languageSwitch.setOnValueChangeListener { isOn in
            print(isOn)
           AppDelegate.shared.rootViewController.show(.main)
        }
    }
    
    private func setupDate(){
        // Big enough frame
        let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 420)
        let pickerWrapperView = UIView(frame: rect)
        pickerWrapperView.addSubview(datePicker)

        // Adding constraints
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.leadingAnchor.constraint(equalTo: pickerWrapperView.leadingAnchor).isActive = true
        datePicker.trailingAnchor.constraint(equalTo: pickerWrapperView.trailingAnchor).isActive = true
        datePicker.topAnchor.constraint(equalTo: pickerWrapperView.topAnchor).isActive = true
        datePicker.bottomAnchor.constraint(equalTo: pickerWrapperView.bottomAnchor).isActive = true

        // Using wrapper view instead of picker
        labelTextField.inputView = pickerWrapperView
        
//        labelTextField.inputView = datePicker
        configureUI()
    }
    
    func configureUI() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(title: "Done",
                                         style: .done,
                                         target: self,
                                         action: #selector(handleDoneButton(_:)))
        let space = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                    target: nil,
                                    action: nil)
        toolbar.setItems([space, doneButton], animated: true)
        toolbar.tintColor = Color.normalTextColor
        labelTextField.inputAccessoryView = toolbar
    }
    
    @objc func handleDoneButton(_ textField: UITextField) {
        let formatter = DateFormatter()
        formatter.dateFormat = App.Format.responseTime
        let selectedDate = formatter.string(from: datePicker.date)
        labelTextField.endEditing(true)
    }
    
    func changeName(){
//        titleLabel.text = User.shared.name
//        titleLabel.text = String.localizable
        Language.localized("vietnamese")
    }
    @IBAction func tableBtnTapped(_ sender: Any) {
        print("Table")
        changeName()
        
        let newController = TableScreenViewController()
        self.navigationController?.pushViewController(newController, animated: true)
    }
    
    @IBAction func collectionBtnTapped(_ sender: Any) {
        print("Collection")
        print(Locale.current.languageCode)
        changeName()
    }
    
}


//
//  RegisterView.swift
//  LongTester
//
//  Created by Long on 6/6/23.
//

import Foundation
import UIKit
import SnapKit
import RealmSwift
import RxSwift

class RegisterView : UIView {
    @IBOutlet weak var maleLbl: UILabel!

    @IBOutlet weak var femaleBtn: UIButton!
    @IBOutlet weak var maleBtn: UIButton!
    @IBOutlet weak var emailTextField: TextFieldView!
    @IBOutlet weak var passwordTextField: TextFieldView!
    @IBOutlet weak var confirmPassTextField: TextFieldView!
    @IBOutlet weak var nameTextField: TextFieldView!
    @IBOutlet weak var phoneTextField: TextFieldView!
    @IBOutlet weak var dobView: UIView!
    @IBOutlet weak var femaleLbl: UILabel!
    @IBOutlet weak var dobTextField: DateSelectView!
    
    @IBOutlet weak var registerBtn: UIButton!
    var baseVC : BaseViewController!
    var viewModel = RegisterViewModel()
    let disposeBag = DisposeBag()
    
    init(frame: CGRect, baseVC: BaseViewController) {
        super.init(frame: frame)
        self.baseVC = baseVC
        commonInit()
    }
    
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
        setup()
        bindToViewModel()
       
    }
    
    private func bindToViewModel() {
        self.viewModel = RegisterViewModel(rootViewModel: baseVC.rootViewModel)
        self.viewModel.isMale.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.updateRadio()
            
        }).disposed(by: disposeBag)
    }
    
    private func setup(){
        femaleLbl.text = Language.localized("female")
        maleLbl.text = Language.localized("male")
        emailTextField.setup(text: Language.localized("username"),isCompulsory: true)
        passwordTextField.setup(text: Language.localized("password"),isSecure: true, isCompulsory: true)
        confirmPassTextField.setup(text: Language.localized("confirmPass"),isSecure: true,isCompulsory: true)
        nameTextField.setup(text: Language.localized("fullname"))
        phoneTextField.setup(text: Language.localized("phone"))
        dobTextField.addPlaceHolder(text: Language.localized("birthday"))
        
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPassTextField.delegate = self
        
        registerBtn.setTitle(Language.localized("registerAccount"), for: .normal)
        registerBtn.layer.cornerRadius = 5
        registerBtn.layer.borderWidth = 1
        registerBtn.layer.borderColor = Color.normalTextColor.cgColor
        registerBtn.layer.masksToBounds = true
        self.layoutIfNeeded()
    }
    
    private func updateRadio(){
        let check = UIImage(named: "radioCheck")
        let uncheck = UIImage(named: "radioUncheck")
        let currentData = viewModel.isMale.value
        femaleBtn.setImage(currentData ? uncheck : check, for: .normal)
        maleBtn.setImage(currentData ? check : uncheck, for: .normal)
    }
    @IBAction func femaleBtnPressed(_ sender: Any) {
        viewModel.setMaleData(isMale: false)
    }
    @IBAction func maleBtnPressed(_ sender: Any) {
        viewModel.setMaleData(isMale: true)
    }
    @IBAction func registerBtnPressed(_ sender: Any) {
        let textFieldValidation = emailTextField.checkValidation() &&
            passwordTextField.checkValidation() &&
            confirmPassTextField.checkValidation()
            
        if (!textFieldValidation || passwordTextField.getData() != confirmPassTextField.getData()) {
            return
        }
    }
}

extension RegisterView : TextFieldViewDelegate {
    func handleErrorMessage(text: String) {
        self.baseVC.rootViewModel.alertModel.accept(AlertModel(message: text))
    }
    
    
}

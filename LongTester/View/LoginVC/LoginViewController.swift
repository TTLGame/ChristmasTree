//
//  LoginViewController.swift
//  LongTester
//
//  Created by Long on 4/17/23.
//

import UIKit
class LoginViewController: BaseViewController {
    @IBOutlet weak var userNameView: TextFieldView!
    @IBOutlet weak var passwordView: TextFieldView!
    
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var languageLbl: UILabel!
    @IBOutlet weak var customSwitch: CustomSwitch!
    @IBOutlet weak var loginBtn: UIButton!
    
    var viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindToViewModel()
    }
    
    private func bindToViewModel() {
        self.viewModel = LoginViewModel(rootViewModel: rootViewModel as! RootViewModel)
        
    }
    
    private func setup(){
        viewModel.setupLanguage()
        userNameView.setup(text: Language.localized("username"))
        passwordView.setup(text: Language.localized("password"),isSecure: true)
        #if DEBUG
        userNameView.addDefaultData(defaultValue: "ttlgame123@gmail.com")
        passwordView.addDefaultData(defaultValue: "tlong123")
        #endif
        customSwitch.delegate = self
        loginBtn.setTitle(Language.localized("login"), for: .normal)
        setSwitchChange()
        
        circleView.layer.cornerRadius = circleView.frame.size.width/2
        circleView.clipsToBounds = true

        circleView.layer.borderColor = Color.darkGreen.cgColor
        circleView.layer.borderWidth = 5.0
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        viewModel.logIn(email: userNameView.getData(),
                        pasword: passwordView.getData())
//        AppDelegate.shared.rootViewController.show(.main)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setSwitchChange() {
        let isOn = AppConfig.shared.language == .vietnamese
        languageLbl.text = AppConfig.shared.language.rawValue
        customSwitch.myColor =  Color.redPrimary
        customSwitch.disableColor = Color.greyPrimary
        customSwitch.isOn = isOn
    }
}

extension LoginViewController : CustomSwitchDelegate {
    func switchShouldChanged(sender: CustomSwitch, value: Bool) {
        
    }
    
    func switchDidChanged(sender: CustomSwitch) {
        print("sender.isOn \(sender.isOn)")
        viewModel.changeLanguage(language : sender.isOn ? .vietnamese : .english)
    }
}

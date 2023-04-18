//
//  LoginViewController.swift
//  LongTester
//
//  Created by Long on 4/17/23.
//

import UIKit
class LoginViewController: UIViewController {
    @IBOutlet weak var userNameView: TextFieldView!
    @IBOutlet weak var passwordView: TextFieldView!
    
    @IBOutlet weak var customSwitch: CustomSwitch!
    @IBOutlet weak var loginBtn: UIButton!
    
    let viewModel = LoginViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup(){
        viewModel.setupLanguage()
        userNameView.setup(text: Language.localized("username"))
        passwordView.setup(text: Language.localized("password"))
        customSwitch.delegate = self
        loginBtn.setTitle(Language.localized("login"), for: .normal)
        setSwitchChange()
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
        AppDelegate.shared.rootViewController.show(.main)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func setSwitchChange() {
        let isOn = AppConfig.shared.language == .vietnamese
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

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
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup(){
        userNameView.setup(text: Language.localized("username"))
        passwordView.setup(text: Language.localized("password"))
        customSwitch.delegate = self
        loginBtn.setTitle(Language.localized("login"), for: .normal)
        setSwitchChange(isOn: true)
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
    
    func setSwitchChange(isOn: Bool) {
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
        AppConfig.shared.language = sender.isOn ? .vietnamese : .english
        AppDelegate.shared.rootViewController.show(.login)
//        self.setSwitchChange(isOn: customSwitch.isOn)
        
    }
    
    
}

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
    
    @IBOutlet weak var loginBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        userNameView.setup(text: "Long")
        // Do any additional setup after loading the view.
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
}

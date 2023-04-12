//
//  ViewController.swift
//  LongTester
//
//  Created by Long on 12/28/22.
//

import UIKit
import RealmSwift
import RxSwift
class MainScreenViewController: UIViewController {

    @IBOutlet weak var languageSwitch: UISwitch!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var labelTextField: UITextField!
    
    //Init realm
    let realm = try! Realm()
    let model = MainScreenViewModel()
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupSwitch()
        bindToViewModel()
        // Do any additional setup after loading the view.
    }
    
    private func bindToViewModel() {
        self.model.title.observe(on: MainScheduler.instance).subscribe{[weak self] value in
            guard let self = self else {return}
            self.labelTextField.text = value
        }
        .disposed(by: disposeBag)
        
        self.model.users.observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] item in
                guard let self = self else {return}
                print("APICALL \(item.count)")
            })
        .disposed(by: disposeBag)
        
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
    
    
    
    func changeName(){
        model.getUserData()
        model.setData()
    }
    
    @IBAction func tableBtnTapped(_ sender: Any) {
        print("Table")
        changeName()
        
        let newController = TableScreenViewController()
        self.navigationController?.pushViewController(newController, animated: true)
    }
    
    @IBAction func collectionBtnTapped(_ sender: Any) {
        print("Collection")
//        print(Locale.current.languageCode)
        changeName()
    }
    
}


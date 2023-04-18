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

    @IBOutlet weak var headerBackGround: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    let model = MainScreenViewModel()
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup(){
//        headerView.addBottomShadow()
        headerBackGround.addBottomShadow()
        headerLbl.text = Language.localized("mainTitle")
        headerLbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
    }

    private func bindToViewModel() {
        self.model.title.observe(on: MainScheduler.instance).subscribe{[weak self] value in
            guard let self = self else {return}
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
   
    func changeName(){
        model.getUserData()
        model.setData()
    }
    
    @IBAction func tableBtnTapped(_ sender: Any) {
        print("Table")
        changeName()
        
        let newController = TableScreenViewController()
        let navigationController = (navigationController as? BaseNavigationView)
        navigationController?.setTitle(title: "Long")
        navigationController?.pushViewController(newController, animated: true)
        
    }
    
    @IBAction func collectionBtnTapped(_ sender: Any) {
        print("Collection")
//        AppDelegate.shared.rootViewController.show(.tableView)
        changeName()
    }
    
}


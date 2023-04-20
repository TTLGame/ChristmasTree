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
    
    @IBOutlet weak var addressTblView: UITableView!
    @IBOutlet weak var headerBackGround: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    
    let viewModel = MainScreenViewModel()
    private let disposeBag: DisposeBag = DisposeBag()
    private var slideMenu = SlideMenuView()
    override func viewDidLoad() {
        super.viewDidLoad()
        bindToViewModel()
        setup()
        // Do any additional setup after loading the view.
    }
    
    private func setup(){
        //        headerView.addBottomShadow()
        headerBackGround.addBottomShadow()
        headerBackGround.backgroundColor = Color.redPrimary
        headerLbl.text = Language.localized("mainTitle")
        headerLbl.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        
        let slideMenu = SlideMenuView(frame: self.view.frame, baseVC: self)
        self.slideMenu = slideMenu
        self.view.addSubview(self.slideMenu)
        
        setupTableView()
        
    }
    
    private func bindToViewModel() {
//        self.model.title.observe(on: MainScheduler.instance).subscribe{[weak self] value in
//            guard let self = self else {return}
//        }
//        .disposed(by: disposeBag)
//        
//        self.model.users.observe(on: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] item in
//                guard let self = self else {return}
//            })
//            .disposed(by: disposeBag)
//        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupTableView(){
        self.addressTblView.register(UINib(nibName: String(describing: TableScreenCell.self), bundle: nil), forCellReuseIdentifier: String(describing: TableScreenCell.self))
        self.addressTblView.delegate = self
        self.addressTblView.dataSource = self
        
    }
    
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        self.slideMenu.handleAction()
        
    }
}

extension MainScreenViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

extension MainScreenViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
//        self.viewModel.cellViewModels.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueCell(TableScreenCell.self)
//        return cell
        
        let cell: TableScreenCell! = tableView.dequeueReusableCell(
            withIdentifier: String(describing: TableScreenCell.self),
            for: indexPath) as? TableScreenCell
        
//        cell.viewModel = viewModel.cellViewModels.value[indexPath.row]
//        cell.renderColor(color: currentColor, pressed : pressed)
        return cell
    }
    
    
}

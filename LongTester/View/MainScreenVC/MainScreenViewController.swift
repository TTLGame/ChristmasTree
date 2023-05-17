//
//  ViewController.swift
//  LongTester
//
//  Created by Long on 12/28/22.
//

import UIKit
import RealmSwift
import RxSwift
class MainScreenViewController: BaseViewController {
    
    @IBOutlet weak var addressTblView: UITableView!
    @IBOutlet weak var headerBackGround: UIView!
    @IBOutlet weak var headerLbl: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var menuBtn: UIButton!
    
    private var viewModel = MainScreenViewModel()
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
        self.viewModel = MainScreenViewModel(rootViewModel: rootViewModel as! RootViewModel)
        self.viewModel.cellViewModels.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.addressTblView.reloadData()
            
        }).disposed(by: disposeBag)
        
        viewModel.getUserData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupTableView(){
        self.addressTblView.register(UINib(nibName: String(describing: MainScreenCell.self), bundle: nil), forCellReuseIdentifier: String(describing: MainScreenCell.self))
        self.addressTblView.delegate = self
        self.addressTblView.dataSource = self        
    }
    
    @IBAction func menuBtnPressed(_ sender: Any) {
        self.slideMenu.handleAction()
        
    }
}

extension MainScreenViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 10))
        bg.backgroundColor = .clear
        return bg
    }
    
}

extension MainScreenViewController : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (viewModel.cellViewModels.value.count == 0) {
            tableView.setEmptyData()
        }
        else {
            tableView.restoreNewProduct()
        }
        return viewModel.cellViewModels.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: MainScreenCell! = tableView.dequeueReusableCell(
            withIdentifier: String(describing: MainScreenCell.self),
            for: indexPath) as? MainScreenCell

        cell.viewModel = viewModel.cellViewModels.value[indexPath.row]
        
        // Highlighted color
        let myCustomSelectionColorView = UIView()
        myCustomSelectionColorView.backgroundColor = .clear
        cell.selectedBackgroundView = myCustomSelectionColorView
        cell.handlePress = {
            self.handlePressData(indexPath: indexPath)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        rootViewModel.alertModel.accept(AlertModel(message: "123"))
        self.handlePressData(indexPath: indexPath)
    }
    
    private func handlePressData(indexPath: IndexPath){
        viewModel.handlePressData(index: indexPath)
    }
}

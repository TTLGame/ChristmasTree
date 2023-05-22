//
//  AddressInfoView.swift
//  LongTester
//
//  Created by Long on 5/18/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AddressInfoView : UIView {
    var baseVC : BaseViewController?
    @IBOutlet weak var tblView: UITableView!
    
    private var viewModel = AddressInfoViewViewModel()
    private let disposeBag = DisposeBag()
    private var mainCellData = [AddressCollectionViewCellViewModel]()
    init(frame: CGRect, data : [AddressCollectionViewCellViewModel], baseVC: BaseViewController) {
        super.init(frame: frame)
        self.baseVC = baseVC
        self.mainCellData = data
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
        bindData()
    }

    override func willMove(toWindow newWindow: UIWindow?) {
        super.willMove(toWindow: newWindow)
        if(newWindow != nil){
            
        }
    }
    
    private func bindData(){
        self.viewModel = AddressInfoViewViewModel(rootViewModel: baseVC?.rootViewModel as! RootViewModel)
        self.viewModel.mainCellData = mainCellData
        self.viewModel.cellViewModels.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.tblView.reloadData()
            
        }).disposed(by: disposeBag)
        self.viewModel.getData()
    }
    
    private func setup(){
        self.tblView.register(UINib(nibName: String(describing: AddressInfoViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AddressInfoViewCell.self))
        self.tblView.delegate = self
        self.tblView.dataSource = self
    }
}

extension AddressInfoView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return section == 0 ? 0 : 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let bg = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: section == 0 ? 0 : 10))
        bg.backgroundColor = .clear
        return bg
    }
}

extension AddressInfoView : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        if (viewModel.cellViewModels.value.count == 0) {
            tableView.setEmptyData()
        }
        else {
            tableView.restoreNewProduct()
        }
        return viewModel.cellViewModels.value.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.value[section].cellViewModels.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddressInfoViewCell! = tableView.dequeueReusableCell(
            withIdentifier: String(describing: AddressInfoViewCell.self),
            for: indexPath) as? AddressInfoViewCell

        cell.viewModel = viewModel.cellViewModels.value[indexPath.section].cellViewModels[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        rootViewModel.alertModel.accept(AlertModel(message: "123"))
//        self.handlePressData(indexPath: indexPath)
    }
}

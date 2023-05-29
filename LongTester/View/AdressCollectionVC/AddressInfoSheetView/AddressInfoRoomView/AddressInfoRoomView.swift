//
//  AddressInfoRoomView.swift
//  LongTester
//
//  Created by Long on 5/26/23.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class AddressInfoRoomView : UIView {
    var baseVC : BaseViewController?
    private var viewModel = AddressInfoRoomViewModel()
    private let disposeBag = DisposeBag()
    private var addressDataModel : AddressDataModel = AddressDataModel()
    private var currentMonthYear = MonthYear()
    private var currentIndex : Int = -1
    private var editMode = false
    
    @IBOutlet weak var detailTblView: UITableView!
    
    @IBOutlet weak var roomLbl: UILabel!
    @IBOutlet weak var waterLbl: UILabel!
    @IBOutlet weak var electricLbl: UILabel!
    @IBOutlet weak var editImgView: UIImageView!
    
    init(frame: CGRect,addressDataModel: AddressDataModel, baseVC: BaseViewController) {
        super.init(frame: frame)
        self.baseVC = baseVC
        self.addressDataModel = addressDataModel
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
    
    private func setup(){
        self.detailTblView.register(UINib(nibName: String(describing: AddressInfoRoomViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AddressInfoRoomViewCell.self))
        self.detailTblView.delegate = self
        self.detailTblView.dataSource = self
        
        self.roomLbl.text = Language.localized("room")
        self.electricLbl.text = Language.localized("electric")
        self.waterLbl.text = Language.localized("water")
        
        editImgView.isUserInteractionEnabled = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(editChangePressed))
        editImgView.addGestureRecognizer(gesture)
    }
    
    @objc func editChangePressed(){
        editMode = !editMode
        self.currentIndex = -1
        self.detailTblView.reloadData()
    }
    private func bindData(){
        self.viewModel = AddressInfoRoomViewModel(rootViewModel: baseVC?.rootViewModel as! RootViewModel)
        self.viewModel.addressDataModel = addressDataModel
        self.viewModel.currentMonthYear = currentMonthYear
        self.viewModel.cellViewModels.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.detailTblView.reloadData()
            
        }).disposed(by: disposeBag)
        
        self.viewModel.addressDataMonthModel.observe(on: MainScheduler.instance).subscribe(onNext: { [weak self] _ in
            guard let self = self else {return}
            self.viewModel.getData(date: self.currentMonthYear)
            
        }).disposed(by: disposeBag)
        self.viewModel.setupData()
    }
}

extension AddressInfoRoomView : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension AddressInfoRoomView : UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.cellViewModels.value.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddressInfoRoomViewCell! = tableView.dequeueReusableCell(
            withIdentifier: String(describing: AddressInfoRoomViewCell.self),
            for: indexPath) as? AddressInfoRoomViewCell
        cell.selectionStyle = .none
        cell.viewModel = viewModel.cellViewModels.value[indexPath.row]
        cell.textFieldConfig(isDisable: !editMode)
//        DispatchQueue.main.async {
//            indexPath.row == self.currentIndex ? cell.selectingCell() : cell.deselectingCell()
//        }
        
        indexPath.row == self.currentIndex ? cell.selectingCell() : cell.deselectingCell()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if editMode {
            return
        }
        let oldIndex = currentIndex
        if (currentIndex == indexPath.row) {
            currentIndex = -1
        }
        else {
            currentIndex = indexPath.row
        }
        if oldIndex == -1 {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        } else {
            tableView.reloadRows(at: [indexPath, IndexPath(row: oldIndex, section: 0)], with: .automatic)
        }
    }
}

extension AddressInfoRoomView {
    func resetMonthYear(monthYear: MonthYear) {
        self.viewModel.getData(date: monthYear)
    }
}

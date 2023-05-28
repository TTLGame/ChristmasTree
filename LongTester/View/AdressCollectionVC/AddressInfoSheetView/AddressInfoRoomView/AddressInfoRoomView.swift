//
//  AddressInfoRoomView.swift
//  LongTester
//
//  Created by Long on 5/26/23.
//

import Foundation
import UIKit
class AddressInfoRoomView : UIView {
    var baseVC : BaseViewController?
    private var addressDataModel : AddressDataModel = AddressDataModel()
    @IBOutlet weak var detailTblView: UITableView!
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
    }
    
    private func setup(){
        self.detailTblView.register(UINib(nibName: String(describing: AddressInfoRoomViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: AddressInfoRoomViewCell.self))
        self.detailTblView.delegate = self
        self.detailTblView.dataSource = self
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
        return 2
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: AddressInfoRoomViewCell! = tableView.dequeueReusableCell(
            withIdentifier: String(describing: AddressInfoRoomViewCell.self),
            for: indexPath) as? AddressInfoRoomViewCell
        cell.selectionStyle = .none
//        cell.viewModel = viewModel.cellViewModels.value[indexPath.section].cellViewModels[indexPath.row]
        return cell
    }
}



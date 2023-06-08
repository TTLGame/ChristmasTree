//
//  OneRoomEditView.swift
//  LongTester
//
//  Created by Long on 6/8/23.
//

import Foundation
import UIKit
import RxSwift

class OneRoomEditView : UIView {
    var baseVC : BaseViewController?
    private var viewModel = AddressInfoRoomViewModel()
    private let disposeBag = DisposeBag()
    private var addressDataModel : AddressDataModel = AddressDataModel()
    private var currentMonthYear = MonthYear()
    
    init(frame: CGRect,addressDataModel: AddressDataModel, currentMonthYear : MonthYear, baseVC: BaseViewController) {
        super.init(frame: frame)
        self.baseVC = baseVC
        self.currentMonthYear = currentMonthYear
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
//        setup()
//        bindData()
    }
    
}

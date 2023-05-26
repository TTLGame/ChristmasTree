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
    
    init(frame: CGRect, baseVC: BaseViewController) {
        super.init(frame: frame)
        self.baseVC = baseVC
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
    }
}


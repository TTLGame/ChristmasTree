//
//  AddressInfoView.swift
//  LongTester
//
//  Created by Long on 5/18/23.
//

import Foundation
import UIKit

class AddressInfoView : UIView {
    var baseVC : UIViewController?
    
    init(frame: CGRect, data : String, baseVC: UIViewController) {
        super.init(frame: frame)
        commonInit()
        self.baseVC = baseVC
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
       
    }
}

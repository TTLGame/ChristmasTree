//
//  ButtonView.swift
//  LongTester
//
//  Created by Long on 2/26/23.
//

import Foundation
import UIKit
class ButtonView : UIView {
    
    @IBOutlet weak var button: UIButton!
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    func commonInit() {
        let view = Bundle.main.loadNibNamed("ButtonView", owner: self, options: nil)?.first as! UIView
        view.frame = self.bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(view)
    }
}

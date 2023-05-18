//
//  BaseSheetView.swift
//  LongTester
//
//  Created by Long on 5/18/23.
//

import Foundation
import UIKit
import SnapKit
class BaseSheetView : UIView {
    enum SheetSize {
        case fixed(CGFloat)
        case fullscreen
        case percent(CGFloat)
    }
    
    private var baseVC : UIViewController?
    @IBOutlet weak var sheetView : UIView!
    @IBOutlet weak var backgroundView : UIView!
    @IBOutlet weak var sheetHeightConstraint: NSLayoutConstraint!
    
    public var size : SheetSize = .fullscreen {
        didSet{
            changeSheetHeight()
        }
    }
    
    public var animate : Bool = true 
    
    init(frame: CGRect, size : SheetSize, baseVC : UIViewController, view : UIView) {
        super.init(frame: frame)
        commonInit()
        
        self.baseVC = baseVC
        self.size = size
        sheetView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
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
        setupUI()
    }
    
    private func setupUI(){
        self.sheetView.roundCorners([.topLeft, .topRight], radius: 30)
    }
    
    private func changeSheetHeight(){
        switch size {
        case .fullscreen:
            sheetHeightConstraint.constant = backgroundView.frame.height
        case let .fixed(height):
            sheetHeightConstraint.constant = height
        case let .percent(percent):
            if (percent > 1 || percent < 0){
                break
            }
            sheetHeightConstraint.constant = backgroundView.frame.height * percent
        }
    }
}

extension BaseSheetView {
    func open(){
        baseVC?.view.addSubview(self)
        baseVC?.view.bringSubviewToFront(self)
        
        if animate {
            sheetView.alpha = 0
            sheetHeightConstraint.constant = 0
            UIView.animate(withDuration: 0.2) {
                self.sheetView.alpha = 1
                self.changeSheetHeight()
                self.layoutIfNeeded()
            } completion: { _ in }
        }
    }
}

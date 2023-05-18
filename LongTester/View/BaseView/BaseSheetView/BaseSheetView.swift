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
    
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var closeBtnSizeConstraint: NSLayoutConstraint!
    @IBOutlet weak var contentView: UIView!
    
    public var size : SheetSize = .fullscreen {
        didSet{
            changeSheetHeight()
        }
    }
    
    public var useDefaultCloseBtn : Bool = true {
        didSet{
            changeExitBtnLayout()
        }
    }
    
    public var hideOnClick : Bool = false {
        didSet{
            if (hideOnClick) {
                if let gestures = backgroundView.gestureRecognizers {
                    if (gestures.isEmpty) {
                        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissableViewTapped))
                        backgroundView.addGestureRecognizer(gestureRecognizer)
                    }
                }
                else {
                    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissableViewTapped))
                    backgroundView.addGestureRecognizer(gestureRecognizer)
                }
            }
            else {
                if let gestures = backgroundView.gestureRecognizers {
                    if (!gestures.isEmpty) {
                        for gesture in gestures {
                            backgroundView.removeGestureRecognizer(gesture)
                        }
                    }
                }
            }
        }
    }
    
    
    public var animate : Bool = true 
    
    init(frame: CGRect, size : SheetSize, baseVC : UIViewController, view : UIView) {
        super.init(frame: frame)
        commonInit()
        
        
        self.baseVC = baseVC
        self.size = size
        
        contentView.addSubview(view)
        view.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        self.tag = 9182
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        hideOnClick = true
        changeSheetHeight()
        changeExitBtnLayout()
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
        closeBtn.setTitle("", for: .normal)
        DispatchQueue.main.async {
            self.sheetView.roundCorners([.topLeft, .topRight], radius: 30)
        }
    }
    
    private func changeSheetHeight(){
        switch size {
        case .fullscreen:
            sheetHeightConstraint.constant = baseVC?.view.frame.height ?? 0
        case let .fixed(height):
            sheetHeightConstraint.constant = height
        case let .percent(percent):
            if (percent > 1 || percent < 0){
                break
            }
            sheetHeightConstraint.constant = (baseVC?.view.frame.height ?? 0) * percent
        }
    }
    
    private func changeExitBtnLayout(){
        closeBtnSizeConstraint.constant = useDefaultCloseBtn ? 30 : 0
        closeBtn.isUserInteractionEnabled = useDefaultCloseBtn
        closeBtn.isHidden = !useDefaultCloseBtn
    }
    
    
    @objc func dismissableViewTapped() {
        close()
    }
    
    @IBAction func closeBtnPressed(_ sender: Any) {
        if useDefaultCloseBtn {
            close()
        }
    }
}

extension BaseSheetView {
    func open(){
        self.baseVC?.view.addSubview(self)
        self.baseVC?.view.bringSubviewToFront(self)
        
        if animate {
            sheetView.alpha = 0
            sheetHeightConstraint.constant = 0
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                UIView.animate(withDuration: 0.3) {
                    self.sheetView.alpha = 1
                    
                    self.changeSheetHeight()
                    self.layoutIfNeeded()
                } completion: { _ in }
            }
        }
    }
    
    func close(){
        
        if animate {
            UIView.animate(withDuration: 0.3) {
                self.sheetView.alpha = 0
                self.sheetHeightConstraint.constant = 0
                self.layoutIfNeeded()
            } completion: { _ in
                self.removeFromSuperview()
            }
        }
    }
    
}

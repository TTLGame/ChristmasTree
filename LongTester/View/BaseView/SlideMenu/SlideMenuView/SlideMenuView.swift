//
//  SlideMenuView.swift
//  LongTester
//
//  Created by Long on 4/19/23.
//

import Foundation
import UIKit

class SlideMenuView : UIView {
    
    
    @IBOutlet weak var sideMenuWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var sideMenuView: SubSlideMenuView!
    @IBOutlet weak var backgroundView: UIView!
    private var sideMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    private var sideMenuShadowView: UIView!
    
    private var baseVC = UIViewController()
    // Expand/Collapse the side menu by changing trailing's constant
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    
    private var revealSideMenuOnTop: Bool = false
    
    init(frame: CGRect, baseVC: UIViewController) {
        super.init(frame: frame)
        self.baseVC = baseVC
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            self.frame.size.height = self.baseVC.view.frame.size.height
        }
        
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
       
        self.backgroundColor = .clear
        self.addLeftShadow()
        
        self.sideMenuWidthConstraint.constant = 0
        self.backgroundView.isHidden = true
        self.backgroundView.isUserInteractionEnabled = false
        self.frame.size.width = 0
        
        
        // Side Menu
        DispatchQueue.main.async {
            self.sideMenuView.defaultHighlightedCell = 0 // Default Highlighted Cell
            self.sideMenuView.delegate = self
           
            self.sideMenuView.translatesAutoresizingMaskIntoConstraints = false
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped))
            self.backgroundView.addGestureRecognizer(tapGesture)
            
        }
    }
    func handleAction(){
        if (isExpanded) {
            hideMenu()
        }
        else {
            openMenu()
        }
        isExpanded = !isExpanded
    }

    @objc func viewTapped(){
        handleAction()
    }
    
    private func hideMenu(){
        print("self.frame.size.height \(self.frame.size.height)")
        print("baseVC.view.frame.size.height \(baseVC.view.frame.size.height)")
        print("-> Slide Menu : HIDE")
        UIView.animate(withDuration: 0.2) {
            self.sideMenuWidthConstraint.constant = 0
            self.backgroundView.isHidden = true
            
            self.backgroundView.isUserInteractionEnabled = false
            self.frame.size.width = 0
            // Call this to trigger refresh constraint
            self.layoutIfNeeded()
        } completion: { _ in
            self.sideMenuView.isHidden = true
        }
    }
    
    private func openMenu(){
        print("-> Slide Menu : OPEN")
        UIView.animate(withDuration: 0.2) {
            self.frame.size.width = self.baseVC.view.frame.size.width
            self.sideMenuWidthConstraint.constant = self.baseVC.view.frame.size.width * 0.7
            self.sideMenuView.isHidden = false
            self.backgroundView.isHidden = false
            
            self.backgroundView.isUserInteractionEnabled = true
            

            // Call this to trigger refresh constraint
            self.layoutIfNeeded()
        } completion: { _ in
            
        }
    }
}

extension SlideMenuView : SubSlideMenuViewDelegate {
    func selectedCell(_ row: Int) {
        print(row)
        handleAction()
    }
}


//
//  SlideMenuViewController.swift
//  LongTester
//
//  Created by Long on 4/19/23.
//

import UIKit

class SlideMenuViewController: UIViewController {
    

    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var sideMenuView: SubSlideMenuView!
    private var sideMenuRevealWidth: CGFloat = 260
    private let paddingForRotation: CGFloat = 150
    private var isExpanded: Bool = false
    private var sideMenuShadowView: UIView!
    
    // Expand/Collapse the side menu by changing trailing's constant
    private var sideMenuTrailingConstraint: NSLayoutConstraint!
    
    private var revealSideMenuOnTop: Bool = false
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .clear
        self.view.addLeftShadow()
        
        // Side Menu
        self.sideMenuView.defaultHighlightedCell = 0 // Default Highlighted Cell
        self.sideMenuView.delegate = self
        // Side Menu AutoLayout
        
        sideMenuView.translatesAutoresizingMaskIntoConstraints = false
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(viewTapped))
        backgroundView.addGestureRecognizer(tapGesture)
    }
      
    @objc func viewTapped(){
        self.dismiss(animated: true)
    }
}

extension SlideMenuViewController : SubSlideMenuViewDelegate {
    func selectedCell(_ row: Int) {
        print(row)
        self.dismiss(animated: true)
    }
}


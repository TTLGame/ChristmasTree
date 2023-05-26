//
//  AddressInfoSheetView.swift
//  LongTester
//
//  Created by Long on 5/26/23.
//

import Foundation
import UIKit

class AddressInfoSheetView : UIView {
    var baseVC : BaseViewController?
    
    @IBOutlet weak var segmentControl: SegmentControl!
    @IBOutlet weak var pageView: PageView!
    
    
    private var pageViews : [UIView] = []
    init(frame: CGRect, baseVC: BaseViewController, pageViews : [UIView]) {
        super.init(frame: frame)
        self.baseVC = baseVC
        self.pageViews = pageViews
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
        setupPageView()
        

    }
    
    private func setup(){
        self.segmentControl.layer.cornerRadius = 10
        self.segmentControl.layer.masksToBounds = true
        self.segmentControl.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        self.segmentControl.delegate = self

        self.segmentControl.cellViewModels = [SegmentControlCellViewModel(title: Language.localized("generalInfo")),
                                              SegmentControlCellViewModel(title: Language.localized("roomsInfo"))]
    }
    
    private func setupPageView(){
        pageView.transitionViews = pageViews
        pageView.animeType = .faded
    }
}

extension AddressInfoSheetView : SegmentControlDelegate {
    func didChangeSegment(indexPath: IndexPath, direction: SegmentControl.Direction) {
        pageView.animeType = .move(direction == .forward ? .reverse : .forward)
        pageView.presentView(interator: indexPath.row)
    }
}

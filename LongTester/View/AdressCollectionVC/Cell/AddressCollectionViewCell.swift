//
//  AddressCollectionViewCell.swift
//  LongTester
//
//  Created by Long on 4/22/23.
//

import UIKit

class AddressCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var bgView: UIView!
    @IBOutlet weak var statusView: UIView!
    @IBOutlet weak var roomNumberLbl: UILabel!
    @IBOutlet weak var rentersLbl: UILabel!
    
    var viewModel: AddressCollectionViewCellViewModel? {
        didSet {
            bindData()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    private func setup(){
        bgView.addBottomShadow(height: 3, alpha: 0.2,radius: 5)
        bgView.layer.masksToBounds = false
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 10
        
        mainView.layer.cornerRadius = 10
        mainView.backgroundColor = .white
        mainView.layer.masksToBounds = true
        
        statusView.layer.cornerRadius = 10
        statusView.layer.masksToBounds = true
        
    }
    
    private func bindData(){
        self.setStatusView()
        if let roomNums = viewModel?.roomNums , let renters = viewModel?.renters {
            roomNumberLbl.text = Language.localized("roomNums") +  String(roomNums)
            rentersLbl.text = Language.localized("renters") + String(renters)
        }
    }
    
    private func setStatusView(){
        switch viewModel?.status {
        case "Paid" :
            statusView.backgroundColor = Color.darkGreen
        case "NotPaid" :
            statusView.backgroundColor = Color.redPrimary
        default:
            statusView.backgroundColor = Color.orangePrimary
        }
    }
}

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
    @IBOutlet weak var statusImgView: UIImageView!
    
    
    @IBOutlet weak var waterTitleLbl: UILabel!
    @IBOutlet weak var electricTitleLbl: UILabel!
    @IBOutlet weak var totalTitleLbl: UILabel!
    @IBOutlet weak var waterAmmountLbl: UILabel!
    @IBOutlet weak var electricAmmountLbl: UILabel!
    @IBOutlet weak var totalAmmountLbl: UILabel!
    @IBOutlet weak var statusImageUIView: UIView!
    
    var viewModel: AddressCollectionViewCellViewModel? {
        didSet {
            bindData()
        }
    }
    
    var enableGesture: Bool = false {
        didSet {
            gestureConfig()
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
        
        waterTitleLbl.text = Language.localized("water")
        electricTitleLbl.text = Language.localized("electric")
        totalTitleLbl.text = Language.localized("total")
        
        addGesture()
    }
    
    private func addGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(pressedStatusImage))
        statusImageUIView.addGestureRecognizer(tap)
    }
    
    @objc func pressedStatusImage(){
        print("pressedStatusImage")
    }
    private func bindData(){
        self.setStatusView()
        if let roomNums = viewModel?.roomNums , let renters = viewModel?.renters {
            roomNumberLbl.text = Language.localized("roomNums") +  String(roomNums)
            rentersLbl.text = Language.localized("renters") + String(renters)
        }
        
       if let water = viewModel?.waterNum,
          let electric = viewModel?.electricNum,
          let total = viewModel?.totalNum {
           waterAmmountLbl.text =  String(water)
           electricAmmountLbl.text =  String(electric)
           totalAmmountLbl.text =  total.formatnumberWithDot() + " VND"
       }
    }
    
    private func gestureConfig(){
        guard let gestures = statusImageUIView.gestureRecognizers else { return }
        
        for gesture in gestures {
            gesture.isEnabled = enableGesture
        }
    }
    
    private func setStatusView(){
        switch viewModel?.status {
        case "Paid" :
            statusView.backgroundColor = Color.darkGreen
            statusImgView.image = UIImage(named: "yesSymbol")
        case "NotPaid" :
            statusView.backgroundColor = Color.redPrimary
            statusImgView.image = UIImage(named: "noSymbol")
        default:
            statusView.backgroundColor = Color.orangePrimary
            statusImgView.image = UIImage(named: "pendingSymbol")
        }
    }
}

//
//  AddressInfoRoomViewCell.swift
//  LongTester
//
//  Created by Long on 5/28/23.
//

import UIKit

class AddressInfoRoomViewCell: UITableViewCell {

    @IBOutlet weak var mainView: UIStackView!
    @IBOutlet weak var waterTextField: UITextField!
    @IBOutlet weak var electricTextField: UITextField!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var waterTitle: UILabel!
    @IBOutlet weak var currentWaterLbl: UILabel!
    @IBOutlet weak var lastWaterLbl: UILabel!
    @IBOutlet weak var totalPriceWaterLbl: UILabel!
    @IBOutlet weak var waterUsedLbl: UILabel!
    @IBOutlet weak var waterPriceLbl: UILabel!
    @IBOutlet weak var quotaUsedLbl: UILabel!
    @IBOutlet weak var quotaPriceLbl: UILabel!
    
    @IBOutlet weak var electricTitle: UILabel!
    @IBOutlet weak var currentElectricLbl: UILabel!
    @IBOutlet weak var lastElectricLbl: UILabel!
    @IBOutlet weak var totalPriceElectricLbl: UILabel!
    @IBOutlet weak var electricUsedLbl: UILabel!
    @IBOutlet weak var electricPriceLbl: UILabel!
    
    @IBOutlet weak var trashTitle: UILabel!
    @IBOutlet weak var trashPriceLbl: UILabel!
    @IBOutlet weak var trashView: UIView!
    
    @IBOutlet weak var internetTitle: UILabel!
    @IBOutlet weak var internetPriceLbl: UILabel!
    @IBOutlet weak var internetView: UIView!
    
    @IBOutlet weak var roomPriceTitle: UILabel!
    @IBOutlet weak var roomPriceLbl: UILabel!
    
    @IBOutlet weak var totalTitle: UILabel!
    @IBOutlet weak var totalLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func setup(){
        
        waterTitle.text = Language.localized("water")
        electricTitle.text = Language.localized("electric")
        trashTitle.text = Language.localized("trashFee")
        internetTitle.text = Language.localized("internetFee")
        roomPriceLbl.text = Language.localized("roomPrice")
        totalTitle.text = Language.localized("total")
    }
}

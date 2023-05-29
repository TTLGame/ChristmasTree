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
    @IBOutlet weak var statusImgView: UIImageView!
    
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
    @IBOutlet weak var roomNumLbl: UILabel!
    
    
    var viewModel : AddressInfoRoomViewCellViewModel? {
        didSet{
            bindData()
        }
    }
    
    private func bindData(){
        guard let viewModel = viewModel else { return }
        
        let currentWater = viewModel.currentWater ?? 0
        let lastWater = viewModel.lastWater ?? 0
        currentWaterLbl.text = String(currentWater)
        lastWaterLbl.text = String(lastWater)
        
        if (currentWater - lastWater > (viewModel.quota ?? 0)){
            quotaUsedLbl.text = String(currentWater - lastWater - (viewModel.quota ?? 0))
        }
        else {
            quotaUsedLbl.text = "0"
        }
        
        quotaPriceLbl.text = "X   " + (viewModel.quotaPrice?.formatnumberWithDot() ?? "0")
        waterUsedLbl.text = String(currentWater - lastWater)
        waterPriceLbl.text = "X   " + (viewModel.waterPrice?.formatnumberWithDot() ?? "0")
        totalPriceWaterLbl.text = (viewModel.totalWater?.formatnumberWithDot() ?? "0") + " VND"
        waterTextField.text = String(currentWater)
        
        let currentElectric = viewModel.currentElectric ?? 0
        let lastElectric = viewModel.lastElectric ?? 0
        currentElectricLbl.text = String(currentElectric)
        lastElectricLbl.text = String(lastElectric)
        electricUsedLbl.text = String(currentElectric - lastElectric)
        electricPriceLbl.text = "X   " +  (viewModel.electricPrice?.formatnumberWithDot() ?? "0")
        totalPriceElectricLbl.text = (viewModel.totalElectric?.formatnumberWithDot() ?? "0") + " VND"
        electricTextField.text = String(currentElectric)
        
        if let trashPrice = viewModel.trashPrice {
            trashPriceLbl.text = trashPrice.formatnumberWithDot() + " VND"
            trashView.isHidden = false
        }
        else {
            trashView.isHidden = true
        }
        
        if let internetPrice = viewModel.internetPrice {
            internetPriceLbl.text = internetPrice.formatnumberWithDot() + " VND"
            internetView.isHidden = false
        }
        else {
            internetView.isHidden = true
        }

        totalLbl.text = (viewModel.total?.formatnumberWithDot() ?? "0") + " VND"
        roomPriceLbl.text = (viewModel.roomPrice?.formatnumberWithDot() ?? "0") + " VND"
        
        roomNumLbl.text = String(viewModel.roomNum ?? 0)
        
        setStatusView()
    }
    
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
        roomPriceTitle.text = Language.localized("roomPrice")
        totalTitle.text = Language.localized("total")
        
        mainView.layer.borderWidth = 1.0
        mainView.layer.borderColor = UIColor.clear.cgColor
        mainView.layer.cornerRadius = 10
        mainView.layer.masksToBounds = true
        
        textFieldConfig(isDisable: true)
    }
    
    func textFieldConfig(isDisable: Bool){
        electricTextField.isUserInteractionEnabled = !isDisable
        waterTextField.isUserInteractionEnabled = !isDisable
        
        electricTextField.backgroundColor = isDisable ? Color.viewDefaultColor : .white
        waterTextField.backgroundColor = isDisable ? Color.viewDefaultColor : .white
        
    }
    private func setStatusView(){
        guard let status = viewModel?.status else { return }
        switch AddressCollectionViewCellViewModel.roomStatus(rawValue: status)  {
        case .paid :
            statusImgView.image = UIImage(named: "yesSymbol")
        case .notPaid :
            statusImgView.image = UIImage(named: "noSymbol")
        case .vacancy:
            statusImgView.image = UIImage(named: "vacancySymbol")
        default:
            statusImgView.image = UIImage(named: "pendingSymbol")
        }
    }
    
    func selectingCell(){
        infoView.isHidden = false
        mainView.backgroundColor = Color.viewDefaultColor
        layoutIfNeeded()
    }
    
    func deselectingCell(){
        self.infoView.isHidden = true
        self.mainView.backgroundColor = .white
        layoutIfNeeded()
    }
}

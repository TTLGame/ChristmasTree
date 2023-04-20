//
//  MainScreenCell.swift
//  LongTester
//
//  Created by Long on 4/20/23.
//

import UIKit
import SDWebImage

class MainScreenCell: UITableViewCell {

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var circleView: UIView!
    @IBOutlet weak var bgView: UIView!
    
    @IBOutlet weak var logoImgView: UIImageView!
    @IBOutlet weak var addressLbl: UILabel!
    @IBOutlet weak var backgroundImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
    var viewModel: MainScreenCellViewModel? {
        didSet {
            bindData()
        }
    }
    
    private func loadImgViewURL(with url : String?) throws -> URL{
        guard let url = url, let url = URL(string: url) else {
            throw ReadError.invalidURL
        }
        return url
    }
    
    private func bindData(){
        self.backgroundImgView.image = UIImage(named: viewModel?.background?.rawValue ?? "PyramidBG")
        self.nameLbl.textColor = viewModel?.background?.font
        self.nameLbl.text = viewModel?.name
        self.addressLbl.text = viewModel?.address
//        self.logoImgView.image = UIImage(named: viewModel?.logo ?? "NoImage")
        
        do {
            let imageURL = try loadImgViewURL(with: viewModel?.logo)
            logoImgView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: "NoImage"))
        } catch ReadError.invalidURL {
            print("Cannot read URL")}
        catch {
            print("Error data")}
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setup()
    }
    func setup(){        
        bgView.addBottomShadow(height: 3, alpha: 0.2)
        bgView.layer.masksToBounds = false
        bgView.backgroundColor = .white
        bgView.layer.cornerRadius = 10
        
        stackView.layer.cornerRadius = 10
        stackView.backgroundColor = .white
        stackView.layer.masksToBounds = true
        circleView.layer.cornerRadius = circleView.frame.size.width/2
        circleView.clipsToBounds = true
        
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}

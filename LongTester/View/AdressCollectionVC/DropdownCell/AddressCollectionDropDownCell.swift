//
//  AddressCollectionDropDownCell.swift
//  LongTester
//
//  Created by Long on 5/16/23.
//

import UIKit


class AddressCollectionDropDownCell: UITableViewCell {
    var viewModel: AddressCollectionDropDownCellViewModel?
    
    @IBOutlet weak var imgView: UIImageView!
//
//    var viewModel: AddressCollectionDropDownCellViewModel? {
//        didSet {
//            bindData()
//        }
//    }
//
//    private func bindData() {
//        imgView.image = viewModel?.image
//    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

//
//  AddressCollectionDropDownCell.swift
//  LongTester
//
//  Created by Long on 5/16/23.
//

import UIKit


class AddressCollectionDropDownCell: BaseCell<AddressCollectionDropDownCellViewModel> {
//    var viewModel: AddressCollectionDropDownCellViewModel?
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
    override var viewModel: AddressCollectionDropDownCellViewModel? {
        didSet {
            bindData()
        }
    }

    private func bindData() {
        imgView.image = viewModel?.image
        titleLbl.text = viewModel?.title
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}

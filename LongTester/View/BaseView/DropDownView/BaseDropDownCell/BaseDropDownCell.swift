//
//  BaseDropDownCell.swift
//  LongTester
//
//  Created by Long on 5/17/23.
//

import UIKit


class BaseDropDownCell: UITableViewCell {

    var viewModel :  BaseDropDownCellViewModel? {
        didSet {
            bindData()
        }
    }
    @IBOutlet weak var titleLbl: UILabel!
    
    private func bindData() {
        self.titleLbl.text = viewModel?.title
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

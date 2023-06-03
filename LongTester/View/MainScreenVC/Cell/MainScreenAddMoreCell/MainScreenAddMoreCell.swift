//
//  MainScreenAddMoreCell.swift
//  LongTester
//
//  Created by Long on 6/2/23.
//

import UIKit

class MainScreenAddMoreCell: UITableViewCell {

    @IBOutlet weak var clickView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        clickView.layer.cornerRadius = 10
        clickView.layer.masksToBounds = true
        DispatchQueue.main.async {
            self.clickView.addDashedBorder(color: Color.redPrimary, radius: 10)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

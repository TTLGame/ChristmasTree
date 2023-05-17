//
//  AddressCollectionDropDownCellViewModel.swift
//  LongTester
//
//  Created by Long on 5/16/23.
//

import Foundation
import UIKit
class AddressCollectionDropDownCellViewModel : BaseDropDownCellViewModel {
    var image : UIImage?
    init(image: UIImage?, title: String?) {
        super.init(title: title)
        self.image = image
    }
}

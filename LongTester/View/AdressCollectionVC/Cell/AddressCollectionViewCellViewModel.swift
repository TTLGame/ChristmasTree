//
//  AddressCollectionViewCellViewModel.swift
//  LongTester
//
//  Created by Long on 4/22/23.
//

import Foundation

class AddressCollectionViewCellViewModel {
    let roomNums : Int?
    let renters : Int?
    let status : String?
    
    init(roomNums: Int?, renters: Int?, status: String?) {
        self.roomNums = roomNums
        self.renters = renters
        self.status = status
    }
    
}

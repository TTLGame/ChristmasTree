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
    let waterNum : Int?
    let electricNum : Int?
    let totalNum : Int?
    init(roomNums: Int?, renters: Int?, status: String?, waterNum: Int?, electricNum: Int?, totalNum: Int?) {
        self.roomNums = roomNums
        self.renters = renters
        self.status = status
        self.waterNum = waterNum
        self.electricNum = electricNum
        self.totalNum = totalNum
    }
}

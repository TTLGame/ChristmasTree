//
//  AddressInfoRoomViewCellViewModel.swift
//  LongTester
//
//  Created by Long on 5/28/23.
//

import Foundation
class AddressInfoRoomViewCellViewModel {
    enum CheckValidationType {
        case water
        case electric
        case all
    }
    let status : String?
    let roomNum : Int?
    
    let lastWater : Int?
    let currentWater : Int?
    let totalWater : Int?
    let waterPrice : Int?
    let quotaPrice : Int?
    let quota : Int?
    
    let lastElectric : Int?
    let currentElectric : Int?
    let electricPrice : Int?
    let totalElectric : Int?
    
    let trashPrice : Int?
    let internetPrice : Int?
    let roomPrice : Int?
    let total : Int?

    var inputWater : Int?
    var inputElectric : Int?
    var inputStatus : String?
    init(status: String?, roomNum: Int?, lastWater: Int?, currentWater: Int?, totalWater: Int?, waterPrice: Int?, quotaPrice: Int?, quota: Int?, lastElectric: Int?, currentElectric: Int?, electricPrice: Int?, totalElectric: Int?, trashPrice: Int?, internetPrice: Int?, roomPrice: Int?, total: Int?) {
        self.status = status
        self.roomNum = roomNum
        self.lastWater = lastWater
        self.currentWater = currentWater
        self.totalWater = totalWater
        self.waterPrice = waterPrice
        self.quotaPrice = quotaPrice
        self.quota = quota
        self.lastElectric = lastElectric
        self.currentElectric = currentElectric
        self.electricPrice = electricPrice
        self.totalElectric = totalElectric
        self.trashPrice = trashPrice
        self.internetPrice = internetPrice
        self.roomPrice = roomPrice
        self.total = total
        
        //For validation
        self.inputWater = currentWater
        self.inputElectric = currentElectric
        self.inputStatus = status
    }
    
    func checkValidation(type : CheckValidationType) -> Bool{
        if let inputWater = inputWater,
           let lastWater = lastWater,
           let inputElectric =  inputElectric,
           let lastElectric = lastElectric {
            switch type {
            case .water :
                return inputWater >= lastWater
            case .electric :
                return inputElectric >= lastElectric
            case .all:
                return inputWater >= lastWater && inputElectric >= lastElectric
            }
        }
        else {
            return false
        }
    }
}

//
//  RoomDataModel.swift
//  LongTester
//
//  Created by Long on 5/24/23.
//

import Foundation
final class RoomDataModel : Codable, Model {
    var status : String?
    var roomNums : Int?
    var renters : Int?
    
    var quota : Int?
    var quotaPrice : Int?
    var waterPrice : Int?
    var waterNum : Int?
    var lastWaterNum : Int?
    
    var electricPrice : Int?
    var electricNum : Int?
    var lastElectricNum : Int?
    
    var roomPrice : Int?
    var totalNum : Int?
    
    init() { }
    init(status: String? = nil, roomNums: Int? = nil, renters: Int? = nil, quota: Int? = nil, quotaPrice: Int? = nil, waterPrice: Int? = nil, waterNum: Int? = nil, lastWaterNum: Int? = nil, electricPrice: Int? = nil, electricNum: Int? = nil, lastElectricNum: Int? = nil,roomPrice : Int? = nil, totalNum: Int? = nil) {
        self.status = status
        self.roomNums = roomNums
        self.renters = renters
        self.quota = quota
        self.quotaPrice = quotaPrice
        self.waterPrice = waterPrice
        self.waterNum = waterNum
        self.lastWaterNum = lastWaterNum
        self.electricPrice = electricPrice
        self.electricNum = electricNum
        self.lastElectricNum = lastElectricNum
        self.roomPrice = roomPrice
        self.totalNum = totalNum
    }
}

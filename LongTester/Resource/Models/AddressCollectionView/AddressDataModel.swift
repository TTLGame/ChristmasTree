//
//  AddressDataModel.swift
//  LongTester
//
//  Created by Long on 5/24/23.
//

import Foundation
import RealmSwift

final class AddressDataModel : Codable, Model {
    var address : String?
    var totalRoom : Int?
    
    var data : [AddressDataMonthModel]?
    
    init() { }
    
    init(address: String? = nil, totalRoom: Int? = nil, data: [AddressDataMonthModel]? = nil) {
        self.address = address
        self.totalRoom = totalRoom
        self.data = data
    }
}

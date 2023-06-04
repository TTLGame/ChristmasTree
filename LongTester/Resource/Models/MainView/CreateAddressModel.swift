//
//  CreateAddressModel.swift
//  LongTester
//
//  Created by Long on 6/4/23.
//

import Foundation

final class CreateAddressModel : Codable, Model {
    var statusCode : Int?
    var messageVN : String?
    var messageEN : String?
    init() { }
    
}

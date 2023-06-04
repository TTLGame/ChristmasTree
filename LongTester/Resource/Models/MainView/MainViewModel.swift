//
//  MainViewModel.swift
//  LongTester
//
//  Created by Long on 6/4/23.
//

import Foundation


final class MainViewModel : Codable, Model {
    var statusCode : Int?
    var messageVN : String?
    var messageEN : String?
    var data : [MainViewDataModel]?
    init() { }
}

final class MainViewDataModel : Codable, Model {
    var name : String?
    var address : String?
    var globalPrice : Int?
    var currentRooms : Int?
    var totalRooms : Int?
    init() { }
}

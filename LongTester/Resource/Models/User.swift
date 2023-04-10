//
//  User.swift
//  LongTester
//
//  Created by Long on 1/3/23.
//

import Foundation
import RealmSwift

final class Pages : Codable {

    var page : Int?
    var per_page : Int?
    var total : Int?
    var total_pages : Int?
    var data : [User]?
    init() { }
    
}

final class User : Codable {
    var id : Int?
    var email : String?
    var firstName : String?
    var lastName : String?
    var avatar : String?
    init() { }
    
}

class RealmModels : Object, Codable {
    @objc dynamic var json : String = ""
    convenience init(json: String) {
        self.init()
        self.json = json
    }
}


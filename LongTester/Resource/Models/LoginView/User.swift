//
//  User.swift
//  LongTester
//
//  Created by Long on 1/3/23.
//

import Foundation
import RealmSwift

final class User : Codable, Model {
    var id : String?
    var email : String?
    var firstName : String?
    var lastName : String?
    var avatar : String?
    init() { }
    
}


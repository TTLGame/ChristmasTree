//
//  TableScreenCellViewModel.swift
//  LongTester
//
//  Created by Long on 1/4/23.
//

import Foundation

class TableScreenCellViewModel {
    let avatar: String?
    let fullName: String?
    init(avatar: String?,
         firstName: String?,
         lastName: String?) {
        self.avatar = avatar
        
        if let firstName = firstName, let lastName = lastName {
            self.fullName = firstName + " " + lastName
        }
        else {
            self.fullName = ""
        }
    }
}

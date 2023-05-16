//
//  Int.swift
//  LongTester
//
//  Created by Long on 5/16/23.
//

import Foundation

extension Int {
    func formatnumberWithDot() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = "."
        formater.numberStyle = .decimal
        return formater.string(from: NSNumber(value: self))!
    }
    
    func formatnumberWithComma() -> String {
        let formater = NumberFormatter()
        formater.groupingSeparator = ","
        formater.numberStyle = .decimal
        return formater.string(from: NSNumber(value: self))!
    }
}

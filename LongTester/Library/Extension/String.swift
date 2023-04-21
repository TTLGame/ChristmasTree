//
//  String.swift
//  LongTester
//
//  Created by Long on 1/4/23.
//

import Foundation


extension String {
    func convertStringToDictionary() -> [String:Any]? {
        var text = self
        text.replaceSubrange(...text.startIndex, with: "{")
        text.replaceSubrange(text.index(before: text.endIndex)...text.index(text.endIndex,offsetBy: -1), with: "}")
//        print(text)
            
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: String]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public func index(of target: String) -> Int? {
        if let range = self.range(of: target) {
            return distance(from: startIndex, to: range.lowerBound)
        } else {
            return nil
        }
    }
}



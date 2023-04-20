//
//  MainScreenCellViewModel.swift
//  LongTester
//
//  Created by Long on 4/20/23.
//

import Foundation
import UIKit

enum backbroundType : String, CaseIterable {
    case pyramid = "PyramidBG"
    case nature = "NatureBG"
    case ship = "ShipBG"
    case snow = "SnowBG"
    case beach = "BeachBG"
    var font : UIColor {
        switch self {
        case .nature, .ship, .pyramid, .snow:
            return .white
        case .beach:
            return .black
            
        }
    }
}
class MainScreenCellViewModel {
    let logo: String?
    let background: backbroundType?
    let name : String?
    let address : String?
    
    init(logo: String?,
         background: backbroundType?,
         name : String?,
         address : String?){
        self.logo = logo
        self.background = background
        self.name = name
        self.address = address
    }
}

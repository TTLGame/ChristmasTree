//
//  MainScreenViewModel.swift
//  LongTester
//
//  Created by Long on 12/28/22.
//

import Foundation
import RxSwift
import RxCocoa
class MainScreenViewModel : NSObject {
    private(set) var title : BehaviorRelay<String> = BehaviorRelay(value: "")
    override init() {
        super.init()
        setData()
    }

    func setData() {
        title.accept("longanhga123")
    }
}


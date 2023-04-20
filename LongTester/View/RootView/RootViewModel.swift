//
//  RootViewModel.swift
//  LongTester
//
//  Created by Long on 4/20/23.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SVProgressHUD

class RootViewModel : NSObject {
    
    func handleProgress(_ value : Bool){
        if (value){
            SVProgressHUD.show(withStatus: "Loading ....")
        } else {
            SVProgressHUD.dismiss()
        }
    }

    override init() {
        super.init()
    }
}

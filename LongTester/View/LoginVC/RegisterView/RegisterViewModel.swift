//
//  RegisterViewModel.swift
//  LongTester
//
//  Created by Long on 6/6/23.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import SVProgressHUD
import OHHTTPStubs
class RegisterViewModel : NSObject {
    var isMale : BehaviorRelay<Bool> = BehaviorRelay(value: true)
    let api: Provider <MultiTarget>
    private(set) var rootViewModel: RootViewModel
    let limit: Int = 50

    let disposeBag = DisposeBag()
    init(rootViewModel : RootViewModel = RootViewModel(), api: Provider<MultiTarget> = ProviderAPIWithAccessToken<MultiTarget>()) {
        self.api = api
        self.rootViewModel = rootViewModel
        super.init()
    }
    
    func setMaleData(isMale: Bool) {
        self.isMale.accept(isMale)
    }
}

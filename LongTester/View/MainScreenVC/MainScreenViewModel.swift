//
//  MainScreenViewModel.swift
//  LongTester
//
//  Created by Long on 12/28/22.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
class MainScreenViewModel : NSObject {
    private(set) var title : BehaviorRelay<String> = BehaviorRelay(value: "")
    private(set) var users : BehaviorRelay<[User]> = BehaviorRelay(value: [])
    let api: Provider<MultiTarget>
    let limit: Int = 50
    
    let disposeBag = DisposeBag()
    
//    User
    init(api: Provider<MultiTarget> = ProviderAPIBasic<MultiTarget>()) {
        self.api = api
        super.init()
//        setData()
//        bindToEvents()
    }
    
    //https://reqres.in/api/users
    func setData() {
        title.accept("longanhga123")
    }
    
    func getUserData() {
        api.request(MultiTarget(MainScreenTarget.getUser(page: 1)))
            .map(Pages.self, using: JSONDecoder.decoderAPI(), failsOnEmptyData: false)
            .subscribe {[weak self] event in
                guard let self = self else { return }
                switch event {
                case .success(let value):
                    print("value of data \(value.data?.count)")
                    if let value = value.data {
                        self.users.accept(value)
                    }
//                    var mutableUsers = Array(self.users.value)
//                    value.data
//                    mutableUsers.insert(contentsOf: value, at: mutableUsers.count)
                    
                case .failure(_):
                    break
                }
            }.disposed(by: disposeBag)
    }
}


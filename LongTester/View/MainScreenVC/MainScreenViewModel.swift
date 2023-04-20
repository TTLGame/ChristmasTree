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
import SVProgressHUD

class MainScreenViewModel : NSObject {
    private(set) var users : BehaviorRelay<[User]> = BehaviorRelay(value: [])
    var cellViewModels : BehaviorRelay<[MainScreenCellViewModel]> = BehaviorRelay(value: [])
    
    let api: Provider<MultiTarget>
    private(set) var rootViewModel: RootViewModel
    let limit: Int = 50
    
    private let randomPic = ["PyramidBG", "NatureBG", "ShipBG", "SnowBG"]
    let disposeBag = DisposeBag()
    init(rootViewModel : RootViewModel = RootViewModel(), api: Provider<MultiTarget> = ProviderAPIBasic<MultiTarget>()) {
        self.api = api
        self.rootViewModel = rootViewModel
        super.init()
        bindToEvents()
    }
    
    func bindToEvents() {
        users.map {users in
            users.map {user in
                return MainScreenCellViewModel(logo: user.avatar,
                                               background: backbroundType(rawValue: self.randomPic[Int.random(in: 0..<4)]),
                                               name: (user.firstName ?? "") + " " + (user.lastName ?? ""),
                                               address: user.email)
            }
        }.bind(to: cellViewModels).disposed(by: disposeBag)
    }
    
    func getUserData() {
        rootViewModel.handleProgress(true)
        api.request(MultiTarget(MainScreenTarget.getUser(page: 1)))
            .map(Pages.self, using: JSONDecoder.decoderAPI(), failsOnEmptyData: false)
            .subscribe {[weak self] event in
                guard let self = self else { return }
                switch event {
                case .success(let value):
                    if let value = value.data {
                        self.users.accept(value)
                        self.rootViewModel.handleProgress(false)
                        SVProgressHUD.dismiss()
                    }
                case .failure(_):
                    break
                }
            }.disposed(by: disposeBag)
    }
}


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
    
    private var randomPic = [String]()
    let disposeBag = DisposeBag()
    init(rootViewModel : RootViewModel = RootViewModel(), api: Provider<MultiTarget> = ProviderAPIBasic<MultiTarget>()) {
        self.api = api
        self.rootViewModel = rootViewModel
        super.init()
        addAllEnumType()
        bindToEvents()
    }
    
    func addAllEnumType(){
        for type in backbroundType.allCases {
            randomPic.append(type.rawValue)
        }
    }
    func bindToEvents() {
        users.map {users in
            users.map {user in
                let current = Int.random(in: 0..<5)
                var total = Int.random(in: 1..<5)
                if (current > total){
                    total = current
                }
                return MainScreenCellViewModel(logo: user.avatar,
                                               background: backbroundType(rawValue: self.randomPic[Int.random(in: 0..<self.randomPic.count)]),
                                               name: (user.firstName ?? "") + " " + (user.lastName ?? ""),
                                               address: user.email,
                                               currentRooms: current,
                                               totalRooms: total)
            }
        }.bind(to: cellViewModels).disposed(by: disposeBag)
    }
    
    func getUserData() {
        var tempUser = [User]()
        rootViewModel.handleProgress(true)
        api.request(MultiTarget(MainScreenTarget.getUser(page: 1)))
            .map(Pages.self, using: JSONDecoder.decoderAPI(), failsOnEmptyData: false)
            .subscribe {[weak self] event in
                guard let self = self else { return }
                switch event {
                case .success(let value):
                    if let value = value.data {
                        tempUser.append(contentsOf: value)
                        self.api.request(MultiTarget(MainScreenTarget.getUser(page: 2)))
                            .map(Pages.self, using: JSONDecoder.decoderAPI(), failsOnEmptyData: false)
                            .subscribe {[weak self] event in
                                guard let self = self else { return }
                                switch event {
                                case .success(let value):
                                    if let value = value.data {
                                        tempUser.append(contentsOf: value)
                                        self.users.accept(tempUser)
                                        self.rootViewModel.handleProgress(false)
                                        SVProgressHUD.dismiss()
                                    }
                                case .failure(_):
                                    break
                                }
                            }.disposed(by: self.disposeBag)
                        
//                        self.users.accept(value)
//                        self.rootViewModel.handleProgress(false)
//                        SVProgressHUD.dismiss()
                    }
                case .failure(_):
                    break
                }
            }.disposed(by: disposeBag)
    }
    
    func handlePressData(index : IndexPath){
//        rootViewModel.alertModel.accept(AlertModel(message: "Fail"))
        let alertModel = AlertModel.ActionModel(title: "Open", style: .default, handler: {_ in
            print("Hi")
        })
        let closeModel = AlertModel.ActionModel(title: "Close", style: .default, handler: {_ in
        })
        rootViewModel.alertModel.accept(AlertModel(actionModels: [alertModel,closeModel], title: "ChristmasTree", message: "Pressed in \(index.row)", prefferedStyle: .alert))
    }
}


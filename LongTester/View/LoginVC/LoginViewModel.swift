//
//  LoginViewModel.swift
//  LongTester
//
//  Created by Long on 4/17/23.
//

import Foundation
import RxSwift
import RxCocoa
import Moya
import Alamofire

class LoginViewModel : NSObject {
    let api: Provider <MultiTarget>
    private(set) var rootViewModel: RootViewModel
    let disposeBag = DisposeBag()
    
    init(rootViewModel : RootViewModel = RootViewModel(), api: Provider<MultiTarget> = ProviderAPIBasic<MultiTarget>()) {
        self.api = api
        self.rootViewModel = rootViewModel
        super.init()
    }
    
    func setupLanguage() {
        let newQuery = ["id" : "-1"]
        if let appConfigData = StoreManager.shared.find(AppConfigModel.self, queryParts: newQuery, in: .appConfig) {
            if let language = appConfigData.first?.language {
                AppConfig.shared.language = Language(rawValue: language) ?? .vietnamese
            }
        }
    }
    
    func changeLanguage(language : Language){
        AppConfig.shared.language = language
        addLanguage()
        AppDelegate.shared.rootViewController.show(.login)
    }
    
    func addLanguage(){
        let data = AppConfigModel()
        data.language = AppConfig.shared.language.rawValue
        guard var tmpJson = data.json() else { return }
        tmpJson["id"] = "-1"
        do {
            try StoreManager.shared.save(data: tmpJson, in: .appConfig)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func logIn(email: String, pasword: String) {
        rootViewModel.handleProgress(true)
        api.request(MultiTarget(LoginTarget.login(email: email, password: pasword)))
            .map(LoginModel.self, using: JSONDecoder.decoderAPI(), failsOnEmptyData: false)
            .subscribe {[weak self] event in
                guard let self = self else { return }
                switch event {
                case .success(let value):
                    if let value = value.data,
                       let token = value.token {
                        PrefsImpl.default.saveAccessToken(token)
                        AppDelegate.shared.rootViewController.show(.main)
                        self.rootViewModel.handleProgress(false)
                    }
                case .failure(let error):
                    self.rootViewModel.alertModel.accept(AlertModel(message: error.localizedDescription))
                    self.rootViewModel.handleProgress(false)
                    break
                }
            }.disposed(by: disposeBag)
    }
    
}

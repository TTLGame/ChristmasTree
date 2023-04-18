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
class LoginViewModel : NSObject {
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
    
}

//
//  MainScreenTarget.swift
//  LongTester
//
//  Created by Long on 4/10/23.
//

import Foundation
import Moya

public enum MainScreenTarget {
    case getUser(page: Int)
}

extension MainScreenTarget: TargetType {
    public var method: Moya.Method {
        switch self {
        case .getUser:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getUser(let page):
            return .requestParameters(parameters: ["page":page],
                                      encoding: URLEncoding.default)
        }
    }
    
    public var headers: [String : String]? {
        return ["Content-type": "application/json"]
    }
    
    public var baseURL: URL {
        let host: String = Environment.shared.configuration(.apiHost)
        let path: String = Environment.shared.configuration(.apiPath)
        let baseURL: URL = URL(string: host + path)!
        return baseURL
    }

    public var path: String {
        switch self {
        case .getUser:
            return "users"
        }
    }

    private func dataFromResource(name: String) -> Data {
        guard let url = Bundle.main.url(forResource: name, withExtension: nil),
              let data = try? Data(contentsOf: url) else {
            return Data()
        }
        return data
    }

    

    public var validationType: ValidationType {
        return .successCodes
    }
    
    
}

extension MainScreenTarget: AccessTokenAuthorizable {
    public var authorizationType: AuthorizationType? {
        return .bearer
    }
}

//
//  AddressCollectionTarget.swift
//  LongTester
//
//  Created by Long on 5/25/23.
//

import Foundation
import Moya

public enum AddressCollectionTarget {
    case getAddressData(id: String)
}

extension AddressCollectionTarget: TargetType {
    public var method: Moya.Method {
        switch self {
        case .getAddressData:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case .getAddressData(let id):
            return .requestPlain
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
        case .getAddressData:
            return "getaddress"
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

extension AddressCollectionTarget: AccessTokenAuthorizable {
    public var authorizationType: AuthorizationType? {
        return .bearer
    }
}

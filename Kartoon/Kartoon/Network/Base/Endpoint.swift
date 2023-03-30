//
//  Endpoint.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 30.03.2023.
//

import Foundation
import Alamofire

enum Endpoint {
    case list(page: Int, pageSize: Int), search(name: String), detail(id: Int)
}

extension Endpoint: TargetType {
    
    var baseURL: String {
        return AppConstants.BASE_API_URL
    }
    
    var path: String {
        switch self {
        case .list:
            return "/characters/?"
        case .search:
            return "/character?"
        case .detail(let id):
            return "/characters/\(id)"
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .list, .search, .detail: return .get
        }
    }
    
    var task: Task {
        switch self {
        case .list(let page, let pageSize):
            return .requestParameters(parameters: ["page" : page, "pageSize" : pageSize], encoding: URLEncoding.default)
        case .search(let name):
            return .requestParameters(parameters: ["name" : name], encoding: URLEncoding.default)
        case .detail:
            return .requestPlain
        }
    }
    
    var headers: HTTPHeaders? {
        switch self {
        default:
            return nil
        }
    }
    
}

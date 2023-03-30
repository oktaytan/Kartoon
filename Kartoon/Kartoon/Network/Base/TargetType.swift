//
//  TargetType.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 30.03.2023.
//

import Foundation
import Alamofire

public enum Task {
    case requestPlain
    case requestParameters(parameters: [String : Any], encoding: ParameterEncoding)
}

public protocol TargetType {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var task: Task { get }
    var headers: HTTPHeaders? { get }
}

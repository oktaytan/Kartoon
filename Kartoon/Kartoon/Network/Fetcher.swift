//
//  Fetcher.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 30.03.2023.
//

import Foundation
import Alamofire
import PromiseKit


final class Fetcher {
    
    static let shared = Fetcher()
    
    private init() {}
    
    private func buildParams(task: Task) -> ([String : Any], ParameterEncoding) {
        switch task {
        case .requestPlain:
            return ([:], URLEncoding.default)
        case .requestParameters(let parameters, let encoding):
            return (parameters, encoding)
        }
    }
    
    func fetch<M: Codable, T: TargetType>(target: T) -> Promise<M> {
        
        let parameters = buildParams(task: target.task)
        
        return Promise<M> { seal in
            AF.request(target.baseURL + target.path, method: target.method, parameters: parameters.0, encoding: parameters.1, headers: target.headers).responseData { (data: AFDataResponse<Data>) in
                
                guard data.response?.statusCode == 200 else {
                    seal.reject(self.processError(error: .notFound, code: data.response?.statusCode))
                    return
                }
                
                switch data.result {
                case .success(let result):
                    let decoder = JSONDecoder()
                    do {
                        seal.fulfill(try decoder.decode(M.self, from: result))
                    } catch {
                        seal.reject(self.processError(error: .parse, code: data.response?.statusCode))
                    }
                case .failure:
                    seal.reject(self.processError(error: .failure, code: data.response?.statusCode))
                }
            }
        }
    }
    
    
    func fetchJSON<M: Codable>(from file: String) -> Promise<M> {
        return Promise<M> { seal in
            guard let url = Bundle.main.url(forResource: file, withExtension: "json") else {
                seal.reject(self.processError(error: .invalidPath, code: nil))
                return
            }
            
            do {
                let data = try Data(contentsOf: url, options: .mappedIfSafe)
                let result = try JSONDecoder().decode(M.self, from: data)
                seal.fulfill(result)
            } catch {
                seal.reject(self.processError(error: .parse, code: nil))
            }
        }
    }
    
    
    // MARK: - Process Error
    private func processError(error: CustomError, code: Int?) -> NSError {
        let responseError =  NSError(domain: Bundle.main.bundleIdentifier ?? "",
                                     code: code ?? 0,
                                     userInfo: [NSLocalizedDescriptionKey : error.rawValue])
        return responseError
    }
    
}

//
//  KartoonRepository.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 30.03.2023.
//

import Foundation

protocol KartoonRepository {
    typealias ListCompletionType = (CharacterList?, Error?) -> Void
    typealias DetailCompletionType = (Character?, Error?) -> Void
    
    func list(page: Int, pageSize: Int, completion: @escaping ListCompletionType)
    func search(name: String, completion: @escaping ListCompletionType)
    func detail(id: Int, completion: @escaping DetailCompletionType)
}


struct KartoonRepositoryImpl: KartoonRepository {
    func list(page: Int, pageSize: Int, completion: @escaping ListCompletionType) {
        Fetcher.shared.fetch(target: Endpoint.list(page: page, pageSize: pageSize)).done { (response: CharacterList) in
            completion(response, nil)
        }.catch { error in
            completion(nil, error)
        }
    }
    
    func search(name: String, completion: @escaping ListCompletionType) {
        Fetcher.shared.fetch(target: Endpoint.search(name: name)).done { (response: CharacterList) in
            completion(response, nil)
        }.catch { error in
            completion(nil, error)
        }
    }
    
    func detail(id: Int, completion: @escaping DetailCompletionType) {
        Fetcher.shared.fetch(target: Endpoint.detail(id: id)).done { (response: Character) in
            completion(response, nil)
        }.catch { error in
            completion(nil, error)
        }
    }
}


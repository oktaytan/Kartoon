//
//  DetailInteractor.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 1.04.2023.
//

import Foundation

final class DetailInteractor: DetailPresenterToInteractorProtocol {
    
    var presenter: DetailInteractorToPresenterProtocol?
    var repo: KartoonRepository
    var id: Int
    
    init(id: Int, repo: KartoonRepository) {
        self.repo = repo
        self.id = id
    }
    
    func load() {
        self.presenter?.handleOutput(.showLoading(true))
        repo.detail(id: self.id) { [weak self] result, error in
            self?.presenter?.handleOutput(.showLoading(false))
            
            guard error == nil, let item = result else {
                self?.presenter?.handleOutput(.showError(error))
                return
            }
            
            self?.presenter?.handleOutput(.load(item))
        }
    }
}

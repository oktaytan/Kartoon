//
//  ListInteractor.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import Foundation

final class ListInteractor: ListPresenterToInteractorProtocol {
    
    var presenter: ListInteractorToPresenterProtocol?
    var repo: KartoonRepository
    private var page: Int = 1
    private var pageSize: Int = 20
    private var totalPages: Int = 0
    
    init(repo: KartoonRepository) {
        self.repo = repo
    }
    
    func load(nextPage: Bool) {
        if checkPageAvailable(next: nextPage)  {
            page += 1
        }
        
        if !nextPage {
            self.presenter?.handleOutput(.showLoading(true))
        }
        
        repo.list(page: page, pageSize: 20) { [weak self] result, error in
            if !nextPage {
                self?.presenter?.handleOutput(.showLoading(false))
            }
            
            guard error == nil else {
                self?.presenter?.handleOutput(.showError(error))
                return
            }
            
            guard let data = result?.data else {
                self?.presenter?.handleOutput(.load([], next: nextPage))
                return
            }
            
            self?.totalPages = result?.totalPages ?? 0
            self?.presenter?.handleOutput(.load(data, next: nextPage))
        }
    }
    
    private func checkPageAvailable(next: Bool) -> Bool {
        return next && (page < totalPages)
    }
}

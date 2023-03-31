//
//  SearchInteractor.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import Foundation

final class SearchInteractor: SearchPresenterToInteractorProtocol {
    
    var presenter: SearchInteractorToPresenterProtocol?
    var repo: KartoonRepository
    
    private var pendingRequestWorkItem: DispatchWorkItem?
    private var searchText: String = ""
    
    init(repo: KartoonRepository) {
        self.repo = repo
    }
    
    func search(text: String) {
        self.searchText = text
        cancel()
        setWorkItem()
    }
    
    func cancel() {
        pendingRequestWorkItem?.cancel()
    }
    
    /// Birden çok servis isteğini engellemek için çalışır.
    private func setWorkItem() {
        let requestWorkItem = DispatchWorkItem(qos: .background) { [weak self] in
            self?.fetchItems()
        }
        
        pendingRequestWorkItem = requestWorkItem
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: requestWorkItem)
    }
    
    private func fetchItems() {
        presenter?.handleOutput(.showLoading(true))
        repo.search(name: self.searchText) { [weak self] result, error in
            self?.presenter?.handleOutput(.showLoading(false))
            
            guard error == nil else {
                self?.presenter?.handleOutput(.showError(error))
                return
            }
            
            guard let list = result, list.count > 0 else {
                self?.presenter?.handleOutput(.load([]))
                return
            }
            
            self?.presenter?.handleOutput(.load(list.data))
        }
    }
}



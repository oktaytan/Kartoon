//
//  ListPresenter.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import Foundation

final class ListPresenter: ListViewToPresenterProtocol {
    
    var view: ListPresenterToViewProtocol?
    var interactor: ListPresenterToInteractorProtocol?
    var router: ListPresenterToRouterProtocol?
    
    private var items = [ListPresenterOutput.ItemType]()
    
    init(view: ListPresenterToViewProtocol, interactor: ListPresenterToInteractorProtocol, router: ListPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func load(next: Bool) {
        interactor?.load(nextPage: next)
    }
    
    func goToSearch() {
        router?.navigate(to: .search)
    }
    
    func goToDetail(id: Int) {
        router?.navigate(to: .detail(id: id))
    }
    
}


extension ListPresenter {
    private func prepareUI(list: [Character], next: Bool) {
        
        if !next {
            self.items.removeAll()
        }
        
        guard !list.isEmpty else {
            self.view?.handleOutput(.load(list: [ListPresenterOutput.ItemType.empty]))
            return
        }
        
        list.forEach { item in
            self.items.append(.item(entity: ItemEntity(data: item)))
        }
        
        self.view?.handleOutput(.load(list: self.items))
    }
}


extension ListPresenter: ListInteractorToPresenterProtocol {
    func handleOutput(_ output: ListInteractorOuput) {
        switch output {
        case .load(let data, let next):
            self.prepareUI(list: data, next: next)
        case .showLoading(let show):
            self.view?.handleOutput(.showLoading(show))
        case .showError(let error):
            self.view?.handleOutput(.showError(error))
        }
    }
}

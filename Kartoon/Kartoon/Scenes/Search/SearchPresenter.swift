//
//  SearchPresenter.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import Foundation

final class SearchPresenter: SearchViewToPresenterProtocol {
    
    var view: SearchPresenterToViewProtocol?
    var interactor: SearchPresenterToInteractorProtocol?
    var router: SearchPresenterToRouterProtocol?
    
    var items = [SearchPresenterOutput.ItemType]()
    
    init(view: SearchPresenterToViewProtocol, interactor: SearchPresenterToInteractorProtocol, router: SearchPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func load() {
        self.items.removeAll()
        self.items.append(.header(message: "If you have a character in mind,\nyou can use the search field if you want to find it."))
        self.view?.handleOutput(.load(list: self.items))
    }
    
    func search(text: String) {
        interactor?.search(text: text)
    }
    
    func cancelSearch() {
        interactor?.cancel()
    }
    
    func goToDetail(id: Int) {
        router?.navigate(to: .detail(id: id))
    }
}


extension SearchPresenter {
    private func prepareUI(list: [Character]) {
        self.items.removeAll()
        
        if list.isEmpty {
            self.items.append(.empty)
        } else {
            self.items = list.map { SearchPresenterOutput.ItemType.item(entity: ItemEntity(data: $0)) }
        }
        
        self.view?.handleOutput(.load(list: self.items))
    }
}


extension SearchPresenter: SearchInteractorToPresenterProtocol {
    func handleOutput(_ output: SearchInteractorOutput) {
        switch output {
        case .load(let data):
            self.prepareUI(list: data)
        case .showLoading(let show):
            self.view?.handleOutput(.showLoading(show))
        case .showError(let error):
            self.view?.handleOutput(.showError(error))
            self.prepareUI(list: [])
        }
    }
}

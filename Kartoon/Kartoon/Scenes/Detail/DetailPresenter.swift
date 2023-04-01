//
//  DetailPresenter.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 1.04.2023.
//

import Foundation

final class DetailPresenter: DetailViewToPresenterProtocol {
    
    var view: DetailPresenterToViewProtocol?
    var interactor: DetailPresenterToInteractorProtocol?
    var router: DetailPresenterToRouterProtocol?
    
    var sections = [DetailPresenterOutput.SectionType]()
    
    init(view: DetailPresenterToViewProtocol, interactor: DetailPresenterToInteractorProtocol, router: DetailPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func load() {
        interactor?.load()
    }
    
    func back() {
        router?.navigate(to: .back)
    }
}


extension DetailPresenter {
    private func prepareUI(item: Character) {
        self.sections.removeAll()
        
        let entity = DetailEntity(item)
        
        self.sections.append(.main(data: entity.main))
        
        entity.details.forEach { presentation in
            let rows = presentation.items.map { DetailPresenterOutput.RowType.detailRow(data: $0) }
            sections.append(.detail(header: presentation.header, data: rows))
        }
        
        print(self.sections)
        
        self.view?.handleOutput(.load(data: self.sections))
    }
}


extension DetailPresenter: DetailInteractorToPresenterProtocol {
    func handleOutput(_ output: DetailInteractorOutput) {
        switch output {
        case .load(let item):
            self.prepareUI(item: item)
        case .showLoading(let show):
            self.view?.handleOutput(.showLoading(show))
        case .showError(let error):
            self.view?.handleOutput(.showError(error))
        }
    }
}

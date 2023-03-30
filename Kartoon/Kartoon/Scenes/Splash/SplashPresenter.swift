//
//  SplashPresenter.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 29.03.2023.
//

import Foundation


final class SplashPresenter: SplashViewToPresenterProtocol {
    
    var view: SplashPresenterToViewProtocol?
    var interactor: SplashPresenterToInteractorProtocol?
    var router: SplashPresenterToRouterProtocol?
    
    private var items = [SplashPresenterOutput.ItemType]()
    
    init(view: SplashPresenterToViewProtocol, interactor: SplashPresenterToInteractorProtocol, router: SplashPresenterToRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func load() {
        interactor?.load()
    }
    
    func startApp() {
        interactor?.startApp()
    }
    
}

extension SplashPresenter {
    private func prepareUI(list: [SplashEntity]) {
        self.items.removeAll()
        self.items = list.map { .info(entity: $0) }
        self.view?.handleOutput(.loadInfoList(list: self.items))
    }
}


extension SplashPresenter: SplashInteractorToPresenterProtocol {
    func handleOutput(_ output: SplashInteractorOutput) {
        switch output {
        case .loadInfoList(let array):
            self.prepareUI(list: array)
        case .startApp:
            router?.navigate(to: .list)
        }
    }
}

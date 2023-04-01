//
//  DetailRouter.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 1.04.2023.
//

import Foundation

final class DetailRouter: DetailPresenterToRouterProtocol {
    
    var view: BaseViewController
    
    init(view: BaseViewController) {
        self.view = view
    }
    
    static func createModule(id: Int) -> BaseViewController {
        let view = DetailVC(nibName: DetailVC.className, bundle: nil)
        let repo = KartoonRepositoryImpl()
        let interactor = DetailInteractor(id: id, repo: repo)
        let router = DetailRouter(view: view)
        let presenter = DetailPresenter(view: view, interactor: interactor, router: router)
        let provider = DetailTableViewProviderImpl()
        
        view.inject(presenter: presenter, provider: provider)
        interactor.presenter = presenter
        
        return view
    }
    
    func navigate(to route: DetailRoute) {
        switch route {
        case .back:
            self.view.goBack()
        }
    }
}

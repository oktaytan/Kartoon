//
//  SearchRouter.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import Foundation

final class SearchRouter: SearchPresenterToRouterProtocol {
    
    var view: BaseViewController
    
    init(view: BaseViewController) {
        self.view = view
    }
    
    static func crateModule() -> BaseViewController {
        let view = SearchVC(nibName: SearchVC.className, bundle: nil)
        let repo = KartoonRepositoryImpl()
        let interactor = SearchInteractor(repo: repo)
        let router = SearchRouter(view: view)
        let presenter = SearchPresenter(view: view, interactor: interactor, router: router)
        let provider = SearchTableViewProviderImpl()
        
        view.inject(presenter: presenter, provider: provider)
        interactor.presenter = presenter
        
        return view
    }
    
    func navigate(to route: SearchRoute) {
        switch route {
        case .detail(let id):
            let detailVC = DetailRouter.createModule(id: id)
            self.view.navigationController?.pushViewController(detailVC, animated: true)
        case .back:
            self.view.goBack()
        }
    }
}

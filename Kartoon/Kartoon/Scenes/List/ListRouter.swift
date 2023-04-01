//
//  ListRouter.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import Foundation

final class ListRouter: ListPresenterToRouterProtocol {
    
    var navController: BaseNavigationController
    
    init(navController: BaseNavigationController) {
        self.navController = navController
    }
    
    static func crateModule() -> BaseNavigationController {
        let view = ListVC(nibName: ListVC.className, bundle: nil)
        let repo = KartoonRepositoryImpl()
        let interactor = ListInteractor(repo: repo)
        let navigation = BaseNavigationController(rootViewController: view)
        let router = ListRouter(navController: navigation)
        let presenter = ListPresenter(view: view, interactor: interactor, router: router)
        let provider = ListCollectionViewProviderImpl()
        
        view.inject(presenter: presenter, provider: provider)
        interactor.presenter = presenter
        router.navController.viewControllers = [view]
        
        return navigation
    }
    
    func navigate(to route: ListRoute) {
        switch route {
        case .search:
            let searchVC = SearchRouter.crateModule()
            self.navController.pushViewController(searchVC, animated: true)
        case .detail(let id):
            let detailVC = DetailRouter.createModule(id: id)
            self.navController.pushViewController(detailVC, animated: true)
        }
    }
}

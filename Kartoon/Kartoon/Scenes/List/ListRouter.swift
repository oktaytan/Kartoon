//
//  ListRouter.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import UIKit

final class ListRouter: ListPresenterToRouterProtocol {
    
    var navController: UINavigationController
    
    init(navController: UINavigationController) {
        self.navController = navController
    }
    
    static func crateModule() -> UINavigationController {
        let view = ListVC(nibName: ListVC.className, bundle: nil)
        let repo = KartoonRepositoryImpl()
        let interactor = ListInteractor(repo: repo)
        let navigation = UINavigationController(rootViewController: view)
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
            print("search")
        case .detail(let id):
            print(id)
        }
    }
}

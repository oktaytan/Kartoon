//
//  SplashRouter.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 29.03.2023.
//

import UIKit


final class SplashRouter: SplashPresenterToRouterProtocol {
    
    static func createModule() -> BaseViewController {
        let view = SplashVC(nibName: SplashVC.className, bundle: nil)
        let interactor = SplashInteractor(infoFile: "splashInfo", defaults: UserDefaults.standard)
        let router = SplashRouter()
        let presenter = SplashPresenter(view: view,
                                        interactor: interactor,
                                        router: router)
        let provider = SplashCollectionViewProviderImpl()
        
        view.inject(presenter: presenter, provider: provider)
        interactor.presenter = presenter
        return view
    }
    
    func navigate(to route: SplashRoute) {
        switch route {
        case .list:
            showListVC()
        }
    }
}


extension SplashRouter {
    private func showListVC() {
        let listVC = ListRouter.createModule()
        AppDesign.Window?.rootViewController = listVC
    }
}

//
//  SplashContracts.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 29.03.2023.
//

import Foundation


// MARK: - VIEW
protocol SplashViewToPresenterProtocol: AnyObject {
    
    var view: SplashPresenterToViewProtocol? { get set }
    var interactor: SplashPresenterToInteractorProtocol? { get set }
    var router: SplashPresenterToRouterProtocol? { get set }
    
    func load()
    func startApp()
    
}

// MARK: - INTERACTOR
protocol SplashPresenterToInteractorProtocol: AnyObject {
    var presenter: SplashInteractorToPresenterProtocol? { get set }
    func load()
    func startApp()
}

enum SplashInteractorOutput {
    case loadInfoList([SplashEntity])
    case startApp
}

protocol SplashInteractorToPresenterProtocol: AnyObject {
    func handleOutput(_ output: SplashInteractorOutput)
}


// MARK: - PRESENTER
enum SplashPresenterOutput {
    enum ItemType {
        case info(entity: SplashEntity)
    }
    
    case loadInfoList(list: [ItemType])
}

protocol SplashPresenterToViewProtocol: AnyObject {
    func handleOutput(_ output: SplashPresenterOutput)
}


// MARK: - ROUTER
enum SplashRoute {
    case list
}

protocol SplashPresenterToRouterProtocol: AnyObject {    
    static func createModule() -> BaseViewController
    func navigate(to route: SplashRoute)
}

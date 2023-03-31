//
//  ListContracts.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import Foundation

// MARK: - VIEW
protocol ListViewToPresenterProtocol: AnyObject {
    
    var view: ListPresenterToViewProtocol? { get set }
    var interactor: ListPresenterToInteractorProtocol? { get set }
    var router: ListPresenterToRouterProtocol? { get set }
    
    func load(next: Bool)
    func goToSearch()
    func goToDetail(id: Int)
}


// MARK: - INTERACTOR
protocol ListPresenterToInteractorProtocol: AnyObject {
    var presenter: ListInteractorToPresenterProtocol? { get set }
    var repo: KartoonRepository { get set }
    
    func load(nextPage: Bool)
}

enum ListInteractorOuput {
    case load(_ data: [Character], next: Bool), showLoading(_ show: Bool), showError(_ error: Error?)
}

protocol ListInteractorToPresenterProtocol: AnyObject {
    func handleOutput(_ output: ListInteractorOuput)
}


// MARK: - PRESENTER
enum ListPresenterOutput {
    enum ItemType {
        case item(entity: ItemEntity), empty
    }
    
    case load(list: [ItemType]), showLoading(_ show: Bool), showError(_ error: Error?)
}

protocol ListPresenterToViewProtocol: AnyObject {
    func handleOutput(_ output: ListPresenterOutput)
}


// MARK: - ROUTER
enum ListRoute {
    case search, detail(id: Int)
}

protocol ListPresenterToRouterProtocol: AnyObject {
    static func crateModule() -> BaseNavigationController
    func navigate(to route: ListRoute)
}

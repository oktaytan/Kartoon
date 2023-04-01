//
//  SearchContracts.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import Foundation

// MARK: - VIEW
protocol SearchViewToPresenterProtocol: AnyObject {
    
    var view: SearchPresenterToViewProtocol? { get set }
    var interactor: SearchPresenterToInteractorProtocol? { get set }
    var router: SearchPresenterToRouterProtocol? { get set }
    
    func load()
    func search(text: String)
    func cancelSearch()
    func goToDetail(id: Int)
}

// MARK: - INTERACTOR
protocol SearchPresenterToInteractorProtocol: AnyObject {
    var presenter: SearchInteractorToPresenterProtocol? { get set }
    var repo: KartoonRepository { get set }
    
    func search(text: String)
    func cancel()
}

enum SearchInteractorOutput {
    case load(_ data: [Character]), showLoading(_ show: Bool), showError(_ error: Error?)
}

protocol SearchInteractorToPresenterProtocol: AnyObject {
    func handleOutput(_ output: SearchInteractorOutput)
}


// MARK: - PRESENTER
enum SearchPresenterOutput {
    enum ItemType {
        case item(entity: SearchEntity), header(message: String), empty
    }
    
    case load(list: [ItemType]), showLoading(_ show: Bool), showError(_ error: Error?)
}

protocol SearchPresenterToViewProtocol: AnyObject {
    func handleOutput(_ output: SearchPresenterOutput)
}


// MARK: - ROUTER
enum SearchRoute {
    case detail(id: Int), back
}

protocol SearchPresenterToRouterProtocol: AnyObject {
    static func createModule() -> BaseViewController
    func navigate(to route: SearchRoute)
}

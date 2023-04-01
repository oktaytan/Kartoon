//
//  DetailContracts.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 1.04.2023.
//

import Foundation

// MARK: - VIEW
protocol DetailViewToPresenterProtocol: AnyObject {
    
    var view: DetailPresenterToViewProtocol? { get set }
    var interactor: DetailPresenterToInteractorProtocol? { get set }
    var router: DetailPresenterToRouterProtocol? { get set }
    
    func load()
    func back()
}

// MARK: - INTERACTOR
protocol DetailPresenterToInteractorProtocol: AnyObject {
    var presenter: DetailInteractorToPresenterProtocol? { get set }
    var repo: KartoonRepository { get set }
    var id: Int { get set }
    
    func load()
}

enum DetailInteractorOutput {
    case load(_ data: Character), showLoading(_ show: Bool), showError(_ error: Error?)
}

protocol DetailInteractorToPresenterProtocol: AnyObject {
    func handleOutput(_ output: DetailInteractorOutput)
}

// MARK: - PRESENTER
enum DetailPresenterOutput {
    enum SectionType {
        case main(data: DetailMainPresentation), detail(header: String, data: [RowType])
    }
    
    enum RowType {
        case detailRow(data: String)
    }
    
    case load(data: [SectionType]), showLoading(_ show: Bool), showError(_ error: Error?)
}

protocol DetailPresenterToViewProtocol: AnyObject {
    func handleOutput(_ output: DetailPresenterOutput)
}

// MARK: - ROUTER
enum DetailRoute {
    case back
}

protocol DetailPresenterToRouterProtocol: AnyObject {
    static func createModule(id: Int) -> BaseViewController
    func navigate(to route: DetailRoute)
}

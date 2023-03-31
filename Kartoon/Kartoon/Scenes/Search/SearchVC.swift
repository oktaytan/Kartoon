//
//  SearchVC.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import UIKit

final class SearchVC: BaseViewController, ListControllerBehaviorally {
    
    typealias Presenter = SearchViewToPresenterProtocol
    typealias Provider = SearchTableViewProvider
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var searchField: CustomSearchField!
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: Presenter!
    var provider: Provider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservationListener()
        setupListView()
        presenter.load()
    }
    
    override func setupView() {
        super.setupView()
        self.setupNavBar(title: nil, leftIcon: "left-fill-icon", rightIcon: nil, leftItemAction: #selector(goBackTapped))
        
        headerView.backgroundColor = .greenLight
        headerView.roundAll(radius: 28, for: .bottom)
    }
    
    func inject(presenter: Presenter, provider: Provider) {
        self.presenter = presenter
        self.provider = provider
    }
    
    func addObservationListener() {
        self.provider.stateClosure = { [weak self] type in
            switch type {
            case .updateUI(let data):
                self?.tableViewUserActivity(event: data)
            case .error(let error):
                self?.handleError(message: error?.localizedDescription)
            }
        }
        
        /// Search Field Listener
        self.searchField.stateClosure = { [weak self] type in
            switch type {
            case .updateUI(let data):
                self?.searchFieldUpdateUIStates(type: data)
            case .error(let error):
                self?.handleError(message: error?.localizedDescription)
            }
        }
    }
    
    func setupListView() {
        provider.setupTableView(tableView: self.tableView)
    }
    
    func handleError(message: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.showToastMessage(title: AppConstants.APP_TITLE, message: message, preset: .error)
        }
    }
    
    func handleLoading(show: Bool) {
        DispatchQueue.main.async { [weak self] in
            show ? self?.showLoading() : self?.hideLoading()
        }
    }
    
    @objc func goBackTapped() {
        self.goBack()
    }
}


extension SearchVC {
    private func tableViewUserActivity(event: SearchTableViewProviderImpl.UserInteractivity?) {
        guard let event = event else { return }
        switch event {
        case .didSelectItem(let id):
            presenter.goToDetail(id: id)
        }
    }
}


extension SearchVC {
    private func searchFieldUpdateUIStates(type: CustomSearchField.UserInteractivity?) {
        switch type {
        case .shouldChangeCharacters(let text):
            presenter.search(text: text)
        case .didBeginEditing(_):
            break
        case .shouldClear(_):
            presenter.cancelSearch()
            presenter.load()
        default:
            break
        }
    }
}


extension SearchVC: SearchPresenterToViewProtocol {
    func handleOutput(_ output: SearchPresenterOutput) {
        switch output {
        case .load(let list):
            provider.setData(data: list)
        case .showLoading(let show):
            self.handleLoading(show: show)
        case .showError(let error):
            self.handleError(message: error?.localizedDescription)
        }
    }
}

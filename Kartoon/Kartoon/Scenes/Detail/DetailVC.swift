//
//  DetailVC.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 1.04.2023.
//

import UIKit

final class DetailVC: BaseViewController, ListControllerBehaviorally {
    
    typealias Presenter = DetailViewToPresenterProtocol
    typealias Provider = DetailTableViewProvider
    
    @IBOutlet weak var tableView: UITableView!
    
    var presenter: Presenter!
    var provider: Provider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservationListener()
        setupListView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presenter.load()
    }
    
    override func setupView() {
        super.setupView()
        self.setupNavBar(title: nil, leftIcon: "left-fill-icon", rightIcon: nil, leftItemAction: #selector(goBackTapped))
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
    }
    
    func setupListView() {
        provider.setupTableView(tableView: self.tableView)
    }
    
    func handleError(message: String?) {
        DispatchQueue.main.async { [weak self] in
            self?.showToastMessage(title: AppConstants.APP_TITLE, message: message, preset: .error)
            DispatchQueue.main.asyncAfter(deadline: .now() + .microseconds(200)) { [weak self] in
                self?.presenter.back()
            }
        }
    }
    
    func handleLoading(show: Bool) {
        DispatchQueue.main.async { [weak self] in
            show ? self?.showLoading() : self?.hideLoading()
        }
    }
    
    @objc func goBackTapped() {
        self.presenter.back()
    }
}


extension DetailVC {
    private func tableViewUserActivity(event: DetailTableViewProviderImpl.UserInteractivity?) {
        // TODO: - If it appears events, we should handle it
    }
}


extension DetailVC: DetailPresenterToViewProtocol {
    func handleOutput(_ output: DetailPresenterOutput) {
        switch output {
        case .load(let data):
            self.provider.setData(data: data)
        case .showLoading(let show):
            self.handleLoading(show: show)
        case .showError(let error):
            self.handleError(message: error?.localizedDescription)
        }
    }
}

//
//  ListVC.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 30.03.2023.
//

import UIKit

final class ListVC: BaseViewController, ListControllerBehaviorally {
    
    typealias Presenter = ListViewToPresenterProtocol
    typealias Provider = ListCollectionViewProvider
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    var presenter: Presenter!
    var provider: Provider!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addObservationListener()
        setupListView()
        presenter.load(next: false)
    }
    
    override func setupView() {
        super.setupView()
        headerView.backgroundColor = .greenLight
        headerView.roundAll(radius: 28, for: .bottom)
        
        titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleLabel.textColor = .greenDark
        titleLabel.text = "Discover"
    }
    
    func inject(presenter: Presenter, provider: Provider) {
        self.presenter = presenter
        self.provider = provider
    }
    
    func addObservationListener() {
        self.provider.stateClosure = { [weak self] type in
            switch type {
            case .updateUI(let data):
                self?.collectionViewUserActivity(event: data)
            case .error(let error):
                self?.handleError(message: error?.localizedDescription)
            }
        }
    }
    
    func setupListView() {
        provider.setupCollectionView(collectionView: self.collectionView)
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
    
    
    @IBAction func searchButtonTapped(_ sender: Any) {
        presenter.goToSearch()
    }
}


extension ListVC {
    private func collectionViewUserActivity(event: ListCollectionViewProviderImpl.UserInteractivity?) {
        guard let event = event else { return }
        switch event {
        case .selectItem(let id):
            presenter.goToDetail(id: id)
        case .preFetch:
            presenter.load(next: true)
        }
    }
}


extension ListVC: ListPresenterToViewProtocol {
    func handleOutput(_ output: ListPresenterOutput) {
        switch output {
        case .load(let list):
            self.provider.setData(data: list)
        case .showLoading(let show):
            self.handleLoading(show: show)
        case .showError(let error):
            self.handleError(message: error?.localizedDescription)
        }
    }
}

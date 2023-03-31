//
//  SplashVC.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 28.03.2023.
//

import UIKit

final class SplashVC: BaseViewController, ListControllerBehaviorally {
    
    typealias Presenter = SplashViewToPresenterProtocol
    typealias Provider = SplashCollectionViewProvider
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: KartoonButton!
    
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
        startButton.setTitle("Start", for: .normal)
        startButton.isHidden = true
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
    
    private func setPageControl(index: Int, last: Bool) {
        self.startButton.isHidden = !last
        self.pageControl.isHidden = last
        self.pageControl.currentPage = index
    }
    
    @IBAction func startButtonTapped(_ sender: Any) {
        presenter.startApp()
    }
    
}

extension SplashVC {
    private func collectionViewUserActivity(event: SplashCollectionViewProviderImpl.UserInteractivity?) {
        guard let event = event else { return }
        switch event {
        case .setPageControl(let index, let last):
            self.setPageControl(index: index, last: last)
        }
    }
}

extension SplashVC: SplashPresenterToViewProtocol {
    func handleOutput(_ output: SplashPresenterOutput) {
        switch output {
        case .loadInfoList(let list):
            self.pageControl.numberOfPages = list.count
            self.provider.setData(data: list)
        }
    }
}

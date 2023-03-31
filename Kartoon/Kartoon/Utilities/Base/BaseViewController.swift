//
//  BaseViewController.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 28.03.2023.
//

import UIKit
import SPIndicator

protocol ListControllerBehaviorally {
    associatedtype Presenter
    associatedtype Provider
    
    func inject(presenter: Presenter, provider: Provider)
    func addObservationListener()
    func setupListView()
    func handleError(message: String?)
    func handleLoading(show: Bool)
}

extension ListControllerBehaviorally {
    func handleError(message: String?) {}
    func handleLoading(show: Bool) {}
}

class BaseViewController: UIViewController {
    
    lazy var loadingView: LoadingView = {
        let loadingView = LoadingView()
        loadingView.modalPresentationStyle = .overCurrentContext
        loadingView.modalTransitionStyle = .crossDissolve
        return loadingView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    func setupView() {
        
    }
    
    // Ekranda üst uyarı barı oluşturur.
    func showToastMessage(title: String?, message: String?, preset: SPIndicatorIconPreset) {
        DispatchQueue.main.async {
            SPIndicator.present(title: title ?? "", message: message, preset: preset)
        }
    }
    
    // Ekranda fullpage loading animasyonu gösterir.
    func showLoading() {
        hideLoading()
        present(loadingView, animated: true)
    }
    
    // Ekrandaki loading animasyonunu kaldırır.
    func hideLoading() {
        loadingView.dismiss(animated: true)
    }
    
    // Navbar'a varsa action ile butonn ekler.
    func setupNavBar(title: String?, leftIcon: String?, rightIcon: String?, leftItemAction: Selector? = nil, rightItemAction: Selector? = nil) {
        if let leftIcon = leftIcon {
            let leftItem = UIBarButtonItem(image: UIImage(named: leftIcon)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: leftItemAction)
            self.navigationItem.leftBarButtonItem = leftItem
        }
        
        if let rightIcon = rightIcon {
            let rightItem = UIBarButtonItem(image: UIImage(named: rightIcon)?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: rightItemAction)
            self.navigationItem.rightBarButtonItem = rightItem
        }
        
        self.title = title
    }
    
    // Önceki controller'a geri döner.
    @objc func goBack() {
        if self.navigationController?.viewControllers.count == 1 {
            self.dismiss(animated: true)
        }else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}

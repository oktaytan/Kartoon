//
//  SplashInteractor.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 29.03.2023.
//

import Foundation


final class SplashInteractor: SplashPresenterToInteractorProtocol {
    
    var presenter: SplashInteractorToPresenterProtocol?
    private var infoList: [SplashEntity] = []

    let infoFile: String
    let defaults: UserDefaults

    init(infoFile: String, defaults: UserDefaults) {
        self.infoFile = infoFile
        self.defaults = defaults
    }
    
    func load() {
        Fetcher.shared.fetchJSON(from: self.infoFile).done { [weak self] (response: [SplashEntity]) in
            self?.infoList = response
            self?.presenter?.handleOutput(.loadInfoList(response))
        }.catch { [weak self] _ in
            self?.startApp()
        }
    }
    
    func startApp() {
        defaults.set(true, forKey: "appStart")
        presenter?.handleOutput(.startApp)
    }
}

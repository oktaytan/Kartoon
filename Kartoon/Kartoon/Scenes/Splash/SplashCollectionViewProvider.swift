//
//  SplashCollectionViewProvider.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 30.03.2023.
//

import UIKit

protocol SplashCollectionViewProvider {
    var stateClosure: ((ObservationType<SplashCollectionViewProviderImpl.UserInteractivity, Error>) -> ())? { get set }
    func setData(data: [SplashPresenterOutput.ItemType]?)
    func collectionViewReload()
    func setupCollectionView(collectionView: UICollectionView)
}


final class SplashCollectionViewProviderImpl: NSObject, CollectionViewProvider, SplashCollectionViewProvider {
    
    typealias T = SplashPresenterOutput.ItemType
    typealias I = IndexPath
    
    var dataList: [T]?
    var stateClosure: ((ObservationType<UserInteractivity, Error>) -> ())?
    
    private var collectionView: UICollectionView?
    
    /// ViewModel' den view'e gelen datayı provider'a gönderir.
    /// - Parameter data: PokeDetailViewModelImpl.SectionType
    func setData(data: [T]?) {
        self.dataList = data
        collectionViewReload()
    }
    
    /// CollectionView'i reload eder.
    func collectionViewReload() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView?.reloadData()
        }
    }
    
    /// CollectionView'i için delegate ve datasource özelliklerini setler. Cell register işlemlerini gerçekleştirir.
    /// - Parameter collectionView: UICollectionView
    func setupCollectionView(collectionView: UICollectionView) {
        self.collectionView = collectionView
        self.collectionView?.backgroundColor = .greenLight
        self.setupCollectionLayout()
        self.collectionView?.register(cellType: SplashInfoCell.self)
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
    }
    
    /// CollectionView için layout setler.
    func setupCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
    }
    
}


extension SplashCollectionViewProviderImpl: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let itemType = self.dataList?[indexPath.item] as? T else { return UICollectionViewCell() }
        switch itemType {
        case .info(let entity):
            let cell = collectionView.dequeueReusableCell(cellType: SplashInfoCell.self, indexPath: indexPath)
            cell.setData(entity)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let itemType = self.dataList?[indexPath.item] as? T else { return .zero }
        switch itemType {
        case .info: return collectionView.bounds.size
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(round(scrollView.contentOffset.x / scrollView.frame.size.width))
        let isLastIndex = currentPage == ((dataList?.count ?? 0) - 1)
        stateClosure?(.updateUI(data: .setPageControl(index: currentPage, last: isLastIndex)))
    }
}


extension SplashCollectionViewProviderImpl {
    enum UserInteractivity {
        case setPageControl(index: Int, last: Bool)
    }
}


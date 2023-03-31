//
//  ListCollectionViewProvider.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import UIKit

protocol ListCollectionViewProvider {
    var stateClosure: ((ObservationType<ListCollectionViewProviderImpl.UserInteractivity, Error>) -> ())? { get set }
    func setData(data: [ListPresenterOutput.ItemType]?)
    func collectionViewReload()
    func setupCollectionView(collectionView: UICollectionView)
}


final class ListCollectionViewProviderImpl: NSObject, CollectionViewProvider, ListCollectionViewProvider {
    
    typealias T = ListPresenterOutput.ItemType
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
        self.collectionView?.backgroundColor = .white
        self.setupCollectionLayout()
        let cells = [ListItemCell.self, EmptyListCell.self]
        self.collectionView?.register(cellTypes: cells)
        self.collectionView?.register(viewType: ListHeaderView.self, kind: UICollectionView.elementKindSectionHeader)
        self.collectionView?.dataSource = self
        self.collectionView?.delegate = self
        self.collectionView?.prefetchDataSource = self
    }
    
    /// CollectionView için layout setler.
    func setupCollectionLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 24
        layout.minimumInteritemSpacing = 24
        self.collectionView?.setCollectionViewLayout(layout, animated: true)
        self.collectionView?.contentInset = UIEdgeInsets(top: 0, left: 24, bottom: 24, right: 24)
    }
}


extension ListCollectionViewProviderImpl: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDataSourcePrefetching, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataList?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let itemType = self.dataList?[indexPath.item] as? T else { return UICollectionViewCell() }
        switch itemType {
        case .item(let entity):
            let cell = collectionView.dequeueReusableCell(cellType: ListItemCell.self, indexPath: indexPath)
            cell.setData(with: entity)
            return cell
        case .empty:
            let cell = collectionView.dequeueReusableCell(cellType: EmptyListCell.self, indexPath: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let itemType = self.dataList?[indexPath.item] as? T else { return .zero }
        switch itemType {
        case .item: return CGSize(width: ((collectionView.bounds.width - (AppDesign.ListItemSpacing * 3)) / 2), height: 200.0)
        case .empty: return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height / 2)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let itemType = self.dataList?[indexPath.item] as? T else { return }
        switch itemType {
        case .item(let entity):
            stateClosure?(.updateUI(data: .selectItem(id: entity.id)))
        default:
            break
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(viewType: ListHeaderView.self, kind: kind, indexPath: indexPath)
            return headerView
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 108)
    }
    
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if indexPath.item == ((self.dataList?.count ?? 0) - 2) {
                stateClosure?(.updateUI(data: .preFetch))
            }
        }
    }
}


extension ListCollectionViewProviderImpl {
    enum UserInteractivity {
        case selectItem(id: Int), preFetch
    }
}

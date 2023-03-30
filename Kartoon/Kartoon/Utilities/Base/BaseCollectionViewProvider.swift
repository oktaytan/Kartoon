//
//  BaseCollectionViewProvider.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 29.03.2023.
//

import Foundation


protocol CollectionViewProvider {
    associatedtype T
    associatedtype I
    
    var dataList: [T]? { get set }
    func setupCollectionLayout()
    func didSelectItem(indexPath: I)
}


extension CollectionViewProvider {
    func setupCollectionLayout() {}
    func didSelectItem(indexPath: I) {}
}

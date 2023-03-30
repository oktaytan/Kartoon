//
//  BaseTableViewProvider.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 29.03.2023.
//

import Foundation


protocol TableViewProvider {
    associatedtype T
    associatedtype I
    
    var dataList: [T]? { get set }
    func didSelectItem(indexPath: I)
}


extension TableViewProvider {
    func didSelectItem(indexPath: I) {}
}

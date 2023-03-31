//
//  SearchTableViewProvider.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import UIKit

protocol SearchTableViewProvider {
    var stateClosure: ((ObservationType<SearchTableViewProviderImpl.UserInteractivity, Error>) -> ())? { get set }
    func setData(data: [SearchPresenterOutput.ItemType]?)
    func tableViewReload()
    func setupTableView(tableView: UITableView)
}


final class SearchTableViewProviderImpl: NSObject, TableViewProvider, SearchTableViewProvider {
    
    typealias T = SearchPresenterOutput.ItemType
    typealias I = IndexPath
    
    var dataList: [T]?
    var stateClosure: ((ObservationType<UserInteractivity, Error>) -> ())?
    
    private var tableView: UITableView?
    
    /// ViewModel' den view'e gelen datayı provider'a gönderir.
    /// - Parameter data: PokeListViewModelImpl.RowType
    func setData(data: [T]?) {
        self.dataList = data
        tableViewReload()
    }
    
    /// TableView'i reload eder.
    func tableViewReload() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView?.reloadData()
        }
    }
    
    /// TableView'in delegate ve datasource özelliklerini setler. Cell register işlemlerini gerçekleştirir.
    /// - Parameter tableView: UITableView
    func setupTableView(tableView: UITableView) {
        self.tableView = tableView
        let cells = [SearchItemCell.self, SearchHeaderCell.self, EmptySearchCell.self]
        self.tableView?.register(cellTypes: cells)
        self.tableView?.delegate = self
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = .none
        self.tableView?.contentInset = UIEdgeInsets(top: 24, left: 0, bottom: 24, right: 0)
    }
}

extension SearchTableViewProviderImpl {
    /// Provider ile ViewController arasındaki iletişim sırasındaki event'leri tanımlar
    enum UserInteractivity {
        case didSelectItem(id: Int)
    }
}

// MARK: - Provider'ın üstlendiği delegate ve dataSource fonksiyonları
extension SearchTableViewProviderImpl: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let rowType = dataList?[indexPath.row] else { return UITableViewCell() }
        switch rowType {
        case .item(let entity):
            let cell = tableView.dequeueReusableCell(with: SearchItemCell.self, for: indexPath)
            cell.setData(entity)
            return cell
        case .header(let message):
            let cell = tableView.dequeueReusableCell(with: SearchHeaderCell.self, for: indexPath)
            cell.setData(message)
            return cell
        case .empty:
            let cell = tableView.dequeueReusableCell(with: EmptySearchCell.self, for: indexPath)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let rowType = dataList?[indexPath.row] else { return 0.0 }
        switch rowType {
        case .item, .header:
            return UITableView.automaticDimension
        case .empty:
            return 2*(tableView.frame.size.height / 3)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let rowType = dataList?[indexPath.row] else { return }
        switch rowType {
        case .item(let entity):
            stateClosure?(.updateUI(data: .didSelectItem(id: entity.id)))
        default:
            break
        }
    }
}

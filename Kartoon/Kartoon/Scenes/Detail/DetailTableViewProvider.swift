//
//  DetailTableViewProvider.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 1.04.2023.
//

import UIKit

protocol DetailTableViewProvider {
    var stateClosure: ((ObservationType<DetailTableViewProviderImpl.UserInteractivity, Error>) -> ())? { get set }
    func setData(data: [DetailPresenterOutput.SectionType]?)
    func tableViewReload()
    func setupTableView(tableView: UITableView)
}


final class DetailTableViewProviderImpl: NSObject, TableViewProvider, DetailTableViewProvider {
    
    typealias T = DetailPresenterOutput.SectionType
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
        let cells = [DetailMainCell.self, DetailItemCell.self]
        self.tableView?.register(cellTypes: cells)
        self.tableView?.dataSource = self
        self.tableView?.separatorStyle = .none
        self.tableView?.sectionHeaderHeight = 16.0
        self.tableView?.sectionFooterHeight = 32.0
        self.tableView?.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 24, right: 0)
    }
}

extension DetailTableViewProviderImpl {
    /// Provider ile ViewController arasındaki iletişim sırasındaki event'leri tanımlar
    enum UserInteractivity {
        
    }
}

// MARK: - Provider'ın üstlendiği delegate ve dataSource fonksiyonları
extension DetailTableViewProviderImpl: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionType = dataList?[section] else { return 0 }
        switch sectionType {
        case .main: return 1
        case .detail(_, let rows): return rows.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let sectionType = dataList?[indexPath.section] else { return UITableViewCell() }
        switch sectionType {
        case .main(let data):
            let cell = tableView.dequeueReusableCell(with: DetailMainCell.self, for: indexPath)
            cell.setData(data)
            return cell
        case .detail(_, let rows): return getCellForSection(rows: rows, tableView: tableView, indexPath: indexPath)
        }
    }
    
    private func getCellForSection(rows: [DetailPresenterOutput.RowType], tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let rowType = rows[indexPath.row]
        switch rowType {
        case .detailRow(let data):
            let cell = tableView.dequeueReusableCell(with: DetailItemCell.self, for: indexPath)
            cell.setData(data)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let sectionType = dataList?[section] else { return nil }
        switch sectionType {
        case .main: return nil
        case .detail(let header, _): return header
        }
    }
}

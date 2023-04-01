//
//  DetailItemCell.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 1.04.2023.
//

import UIKit

class DetailItemCell: UITableViewCell {

    @IBOutlet weak var itemLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        itemLabel.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        itemLabel.textColor = .greenDark
    }
    
    func setData(_ item: String) {
        DispatchQueue.main.async { [weak self] in
            self?.itemLabel.text = item
        }
    }
    
}

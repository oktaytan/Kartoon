//
//  SearchHeaderCell.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 1.04.2023.
//

import UIKit

class SearchHeaderCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        messageLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        messageLabel.textColor = .blackSoft
    }
    
    func setData(_ message: String) {
        DispatchQueue.main.async { [weak self] in
            self?.messageLabel.text = message
        }
    }
    
}

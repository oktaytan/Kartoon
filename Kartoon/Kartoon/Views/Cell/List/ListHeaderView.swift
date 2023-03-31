//
//  ListHeaderView.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import UIKit

class ListHeaderView: UICollectionReusableView {

    @IBOutlet weak var messageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        messageLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        messageLabel.textColor = .blackSoft
        messageLabel.text = "Discover the best Disney characters and choose your favorite character"
    }
    
}

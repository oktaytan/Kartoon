//
//  DetailMainCell.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 1.04.2023.
//

import UIKit

class DetailMainCell: UITableViewCell {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        itemImageView.contentMode = .scaleAspectFill
        
        nameLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        nameLabel.textColor = .blackSoft
    }
    
    func setData(_ data: DetailMainPresentation) {
        DispatchQueue.main.async { [weak self] in
            self?.itemImageView.loadImage(urlString: data.imageURL, placeholder: "placeholder-image")
            self?.nameLabel.text = data.name
        }
    }
}

//
//  SearchItemCell.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import UIKit

class SearchItemCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        containerView.configureShadow(shadowColor: .blackSoft, offset: CGSize(width: 2, height: 4), shadowRadius: 10, shadowOpacity: 0.1, cornerRadius: 14)
        
        itemImageView.roundAll(radius: 14, for: .left)
        itemImageView.contentMode = .scaleAspectFill
        
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        nameLabel.textColor = .blackSoft
    }
    
    func setData(_ item: SearchEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.itemImageView.loadImage(urlString: item.imageURL, placeholder: "placeholder-image")
            self?.nameLabel.text = item.name
        }
    }
}

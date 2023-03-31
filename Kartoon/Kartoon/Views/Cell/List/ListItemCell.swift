//
//  ListItemCell.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import UIKit

class ListItemCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var nameLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        imageView.contentMode = .scaleAspectFill
        imageView.cornerRadius = 14
        
        blurView.roundAll(radius: 14, for: .bottom)
        
        nameLabel.font = UIFont.systemFont(ofSize: 12, weight: .bold)
        nameLabel.textColor = .blackSoft
    }
    
    func setData(with item: ItemEntity) {
        DispatchQueue.main.async { [weak self] in
            self?.imageView.loadImage(urlString: item.imageURL, placeholder: "placeholder-image")
            self?.nameLabel.text = item.name
        }
    }

}

//
//  SplashInfoCell.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 30.03.2023.
//

import UIKit

class SplashInfoCell: UICollectionViewCell {

    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var infoMessageLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    private func setupUI() {
        infoImageView.contentMode = .scaleAspectFit
        infoMessageLabel.font = UIFont.systemFont(ofSize: 16, weight: .light)
    }
    
    func setData(_ entity: SplashEntity) {
        infoImageView.image = UIImage(named: entity.icon)
        infoMessageLabel.text = entity.info
    }
}

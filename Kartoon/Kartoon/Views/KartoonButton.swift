//
//  KartoonButton.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 30.03.2023.
//

import UIKit

class KartoonButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    fileprivate func setupUI() {
        cornerRadius = 10
        backgroundColor = .greenDark
        setTitleColor(UIColor.white, for: .normal)
        titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        frame.size =  CGSize(width: 200, height: 52)
    }
    
}

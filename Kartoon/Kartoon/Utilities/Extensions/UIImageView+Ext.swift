//
//  UIImageView+Ext.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 28.03.2023.
//

import UIKit.UIImageView
import Kingfisher


public extension UIImageView {
    func loadImage(urlString: String, radius: CGFloat = 0, transition: ImageTransition = .fade(0.5), placeholder: String) {
        let processor = DownsamplingImageProcessor(size: self.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: radius)
        
        self.kf.indicatorType = .activity
        
        if let url = URL(string: urlString) {
            self.kf.setImage(
                with: url,
                placeholder: UIImage(named: placeholder)!,
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .transition(transition),
                    .cacheOriginalImage
                ])
        } else {
            self.image = UIImage(named: placeholder)
        }
    }
}

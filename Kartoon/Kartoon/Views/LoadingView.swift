//
//  LoadingView.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 28.03.2023.
//

import UIKit


final class LoadingView: UIViewController {
    
    lazy var loadingImageView: UIImageView = {
        let image = UIImage(named: "loading-icon")!
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        
        imageView.rotation(start: true, direction: .clockwise)
        imageView.autoresizingMask = [
            .flexibleTopMargin, .flexibleBottomMargin,
            .flexibleLeftMargin, .flexibleRightMargin
        ]
        
        return imageView
    }()
    
    lazy var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.5
        
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        
        return blurEffectView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadSubviews()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadingImageView.rotation(start: true, duration: 0.8, direction: .clockwise)
    }
    
    private func loadSubviews() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        
        blurEffectView.frame = self.view.bounds
        view.insertSubview(blurEffectView, at: 0)
        
        loadingImageView.frame.size = CGSize(width: 120, height: 120)
        loadingImageView.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY)
        view.addSubview(loadingImageView)
    }
}

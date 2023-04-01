//
//  UIView+Ext.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 28.03.2023.
//

import UIKit

extension UIView {
    
    class func fromNib<T: UIView>() -> T {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    func loadNib<T: UIView>() -> T {
        let bundle = Bundle(for: T.self)
        let nibName = T.self.description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! T
    }
    
    var cornerRadius: CGFloat {
        get { return layer.cornerRadius }
        set {
            layer.masksToBounds = true
            layer.cornerRadius = newValue
        }
    }
    
    func fullRound() {
        self.cornerRadius = bounds.height / 2
    }
    
    enum MaskCorners {
        case top, bottom, left, right
        
        var masks: CACornerMask {
            switch self {
            case .top: return [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            case .bottom: return [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
            case .left: return [.layerMinXMinYCorner, .layerMinXMaxYCorner]
            case .right: return [.layerMaxXMinYCorner, .layerMaxXMaxYCorner]
            }
        }
    }
    
    func roundAll(radius: CGFloat, for corners: MaskCorners) {
        self.cornerRadius = radius
        self.layer.maskedCorners = corners.masks
    }
    
    public func configureShadow(shadowColor: UIColor, offset: CGSize, shadowRadius: CGFloat, shadowOpacity: Float, cornerRadius: CGFloat, borderColor: UIColor = UIColor.clear, borderWidth: CGFloat = 0.0) {
      layer.shadowColor = shadowColor.cgColor
      layer.shadowOpacity = shadowOpacity
      layer.shadowOffset = offset
      layer.shadowRadius = shadowRadius
      layer.cornerRadius = cornerRadius
      layer.borderColor = borderColor.cgColor
      layer.borderWidth = borderWidth
    }
    
    enum RotationDirection {
        case clockwise, counterClockwise
    }
    
    func rotation(start: Bool, duration: CFTimeInterval = 1, direction: RotationDirection) {
        let toValue = direction == .clockwise ? Double.pi * 2 : -Double.pi * 2
        if start {
            let rotation : CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
            rotation.toValue = NSNumber(value: toValue)
            rotation.duration = duration
            rotation.isCumulative = true
            rotation.repeatCount = .infinity
            self.layer.add(rotation, forKey: "rotationAnimation")
        } else {
            self.layer.removeAnimation(forKey: "rotationAnimation")
        }
    }
}


extension UIView {
    @discardableResult
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat = 0,
                height: CGFloat = 0) -> [NSLayoutConstraint] {
        translatesAutoresizingMaskIntoConstraints = false
        
        var anchors = [NSLayoutConstraint]()
        
        if let top = top {
            anchors.append(topAnchor.constraint(equalTo: top, constant: paddingTop))
        }
        if let left = left {
            anchors.append(leftAnchor.constraint(equalTo: left, constant: paddingLeft))
        }
        if let bottom = bottom {
            anchors.append(bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom))
        }
        if let right = right {
            anchors.append(rightAnchor.constraint(equalTo: right, constant: -paddingRight))
        }
        if width > 0 {
            anchors.append(widthAnchor.constraint(equalToConstant: width))
        }
        if height > 0 {
            anchors.append(heightAnchor.constraint(equalToConstant: height))
        }
        
        anchors.forEach { $0.isActive = true }
        
        return anchors
    }
    
    @discardableResult
    func anchorToSuperview() -> [NSLayoutConstraint] {
        return anchor(top: superview?.topAnchor,
                      left: superview?.leftAnchor,
                      bottom: superview?.bottomAnchor,
                      right: superview?.rightAnchor)
    }
}

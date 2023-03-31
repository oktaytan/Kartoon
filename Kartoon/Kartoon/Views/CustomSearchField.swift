//
//  CustomSearchField.swift
//  Kartoon
//
//  Created by Oktay Tanrıkulu on 31.03.2023.
//

import UIKit

protocol CustomSearchFieldProtocol {
    var stateClosure: ((ObservationType<CustomSearchField.UserInteractivity, Error>) -> ())? { get set }
    func setupUI()
}

class CustomSearchField: UITextField, CustomSearchFieldProtocol {
    
    var stateClosure: ((ObservationType<UserInteractivity, Error>) -> ())?
    let padding = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 55)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.changeClearImage()
    }
    
    func setupUI() {
        self.delegate = self
        self.cornerRadius = 10
        self.backgroundColor = .white
        self.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        self.textColor = .blackSoft
        
        let placeholderAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.greenDark,
            NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16, weight: .regular)
        ]
        
        self.attributedPlaceholder = NSAttributedString(string: placeholder ?? "", attributes: placeholderAttributes)
        self.clearButtonMode = .whileEditing
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override open func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    
    override func clearButtonRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(x: self.frame.size.width - 40, y: 16, width: 20, height: 20)
    }
}


extension CustomSearchField {
    enum UserInteractivity {
        case didBeginEditing(_ textField: UITextField)
        case shouldClear(_ textField: UITextField)
        case shouldReturn(_ textField: UITextField)
        case didChangeSelection(_ newText: String)
        case shouldChangeCharacters(_ newText: String)
    }
}


// MARK: - UITextFieldDelegate
extension CustomSearchField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        stateClosure?(.updateUI(data: .didBeginEditing(textField)))
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        self.text = nil
        stateClosure?(.updateUI(data: .shouldClear(textField)))
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.resignFirstResponder()
        stateClosure?(.updateUI(data: .shouldReturn(textField)))
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        guard let newText = self.text, newText.count > 0 else {
            return
        }
        stateClosure?(.updateUI(data: .didChangeSelection(newText)))
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let newText = (textField.text as NSString?)?.replacingCharacters(in: range, with: string) else { return false }
        if newText == "" {
            stateClosure?(.updateUI(data: .shouldClear(textField)))
        } else {
            stateClosure?(.updateUI(data: .shouldChangeCharacters(newText)))
        }
        return true
    }
}

extension CustomSearchField {
    private func changeClearImage() {
        for view in subviews {
            if view is UIButton {
                let button = view as! UIButton
                if let newImage = UIImage(named: "close-icon") {
                    button.setImage(newImage, for: .normal)
                    button.setImage(newImage, for: .highlighted)
                }
            }
        }
    }
}

//
//  UIFont+Extension.swift
//  PawPics
//
//  Created by Kapil Khedkar on 20/07/24.
//

import Foundation
import UIKit

extension UIFont {
    static func headingLabel(ofSize size: CGFloat = 24.0) -> UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .bold)
    }

    static func titleLabel(ofSize size: CGFloat = 12.0) -> UIFont {
        return UIFont(name: "Montserrat-Regular", size: size) ?? UIFont.systemFont(ofSize: size, weight: .semibold)
    }

    static func buttonText(ofSize size: CGFloat = 16.0) -> UIFont {
        return UIFont(name: "Montserrat-SemiBold", size: size) ?? UIFont.systemFont(ofSize: size, weight: .regular)
    }
}

extension UIButton {
    func themifyButton(title: String) {
        self.setTitle(title, for: .normal)
        self.backgroundColor = .appPrimary
        self.titleLabel?.font = .buttonText()
        self.tintColor = .appSecondary
        self.setTitleColor(.appSecondary, for: .normal)
        self.layer.cornerRadius = 8.0
        self.layer.borderWidth = 1.0
        self.layer.borderColor = UIColor.appSecondary.cgColor
        self.layer.masksToBounds = true
    }
}

extension UITextField {
    var borderColor: UIColor? {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.clear.cgColor)
        }
        set {
            layer.borderColor = newValue?.cgColor
            layer.borderWidth = newValue == nil ? 0 : layer.borderWidth
        }
    }
    
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    func themifyTextField() {
        self.borderStyle = .roundedRect
        self.textColor = .appSecondary
        self.font = .titleLabel()
        self.borderColor = .appSecondary
        self.borderWidth = 1.0
        self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        
        let placeholderText = self.placeholder ?? ""
        let attributes: [NSAttributedString.Key: Any] = [
            .font: UIFont.titleLabel()
        ]
        let attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: attributes)
        self.attributedPlaceholder = attributedPlaceholder
    }
}

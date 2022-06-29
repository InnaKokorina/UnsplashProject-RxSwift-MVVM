//
//  StackViewExtension.swift
//  UnsplashProject
//
//  Created by Inna Kokorina on 27.06.2022.
//

import UIKit

extension UIStackView {
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis, spacing: CGFloat) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.spacing = spacing
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    convenience init(arrangedSubviews: [UIView], axis: NSLayoutConstraint.Axis) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
        self.translatesAutoresizingMaskIntoConstraints = false
    }
}


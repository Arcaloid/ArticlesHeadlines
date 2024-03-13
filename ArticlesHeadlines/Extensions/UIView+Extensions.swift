//
//  UIView+Extensions.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import UIKit

extension UIView {
    func constraintToSuperview() {
        guard let superview else { 
            assertionFailure("No superview exists")
            return
        }
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            topAnchor.constraint(equalTo: superview.topAnchor)
        ])
    }
}

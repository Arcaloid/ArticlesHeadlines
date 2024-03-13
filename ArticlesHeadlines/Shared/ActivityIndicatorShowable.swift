//
//  ActivityIndicatorShowable.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import UIKit

protocol ActivityIndicatorShowable: UIViewController {
    var activityIndicator: UIActivityIndicatorView { get }
    func showIndicator()
    func hideIndicator()
}

extension ActivityIndicatorShowable {
    func showIndicator() {
        if activityIndicator.superview == nil {
            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
            activityIndicator.hidesWhenStopped = true
            view.addSubview(activityIndicator)
            NSLayoutConstraint.activate([
                activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
        }
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
    }
    
    func hideIndicator() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
    }
}

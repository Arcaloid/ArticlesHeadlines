//
//  ErrorRecoverble.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import UIKit

protocol ErrorRecoverble: UIViewController {
    var reloadButton: UIButton { get }
    func showError(message: String)
    func hideReloadButton()
}

extension ErrorRecoverble {
    func showError(message: String) {
        if reloadButton.superview == nil {
            reloadButton.setTitle("Reload", for: .normal)
            reloadButton.setTitleColor(Color.defaultText.uiColor, for: .normal)
            reloadButton.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(reloadButton)
            NSLayoutConstraint.activate([
                reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                reloadButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            ])
            reloadButton.sizeToFit()
        }
        reloadButton.isHidden = false
        
        showErrorAlert(message: message)
    }
    
    func hideReloadButton() {
        reloadButton.isHidden = true
    }
    
    private func showErrorAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okButton)
        present(alertController, animated: true)
    }
}

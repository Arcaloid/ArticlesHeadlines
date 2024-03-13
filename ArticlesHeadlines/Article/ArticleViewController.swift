//
//  ArticleViewController.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import UIKit
import WebKit
import Combine

final class ArticleViewController: UIViewController {
    private let viewModel: ArticleViewModel
    private let webView = WKWebView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ArticleViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        hidesBottomBarWhenPushed = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebView()
        setupSubscriptions()
        webView.load(URLRequest(url: viewModel.articleUrl))
    }
    
    private func setupWebView() {
        webView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(webView)
        webView.constraintToSuperview()
    }
    
    private func setupSubscriptions() {
        viewModel.$isSaved
            .sink { [weak self] in
                self?.setupSaveButton(isSaved: $0)
            }
            .store(in: &cancellables)
        
        viewModel.$error
            .compactMap { $0 }
            .sink { [weak self] in
                self?.showError($0)
            }
            .store(in: &cancellables)
    }
    
    private func setupSaveButton(isSaved: Bool) {
        if isSaved {
            let button = UIButton()
            button.setImage(UIImage(systemName: "star.fill"), for: .normal)
            button.addTarget(self, action: #selector(didTapUnsaveButton), for: .touchUpInside)
            let saveButton = UIBarButtonItem(customView: button)
            navigationItem.rightBarButtonItem = saveButton
        } else {
            let button = UIButton()
            button.setImage(UIImage(systemName: "star"), for: .normal)
            button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
            let saveButton = UIBarButtonItem(customView: button)
            navigationItem.rightBarButtonItem = saveButton
        }
    }
    
    @objc private func didTapSaveButton() {
        viewModel.saveArticle()
    }
    
    @objc private func didTapUnsaveButton() {
        viewModel.unsaveArticle()
    }
    
    private func showError(_ error: Error) {
        let alertController = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let okButton = UIAlertAction(title: "OK", style: .default)
        alertController.addAction(okButton)
        present(alertController, animated: true)
    }
}

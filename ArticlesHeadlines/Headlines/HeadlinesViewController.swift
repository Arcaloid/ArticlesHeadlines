//
//  HeadlinesViewController.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import UIKit

final class HeadlinesViewController: UIViewController {
    private let viewModel = HeadlinesViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        setupView()
        viewModel.loadHeadlines()
    }
    
    private func setupView() {
        let articlesViewController = ArticlesViewController(viewModel: viewModel.articlesViewModel, delegate: self)
        view.addSubview(articlesViewController.view)
        articlesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        articlesViewController.view.constraintToSuperview()
        addChild(articlesViewController)
        
        let refreshButton = UIBarButtonItem(
            barButtonSystemItem: .refresh,
            target: self,
            action: #selector(refresh)
        )
        navigationItem.rightBarButtonItem = refreshButton
    }
    
    @objc private func refresh() {
        viewModel.loadHeadlines()
    }
}

extension HeadlinesViewController: ArticlesViewDelegate {
    func didTapReloadButton() {
        viewModel.loadHeadlines()
    }
}

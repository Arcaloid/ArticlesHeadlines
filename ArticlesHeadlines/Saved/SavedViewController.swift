//
//  SavedViewController.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import UIKit
import Combine

final class SavedViewController: UIViewController {
    private let viewModel = SavedViewModel()
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        setupView()
        setupSubscriptions()
        viewModel.loadSavedArticles()
    }
    
    private func setupView() {
        let articlesViewController = ArticlesViewController(viewModel: viewModel.articlesViewModel, delegate: self)
        view.addSubview(articlesViewController.view)
        articlesViewController.view.translatesAutoresizingMaskIntoConstraints = false
        articlesViewController.view.constraintToSuperview()
        addChild(articlesViewController)
    }
    
    private func setupSubscriptions() {
        NotificationCenter
            .default
            .publisher(for: Notification.Name.NSManagedObjectContextObjectsDidChange)
            .sink { [weak self] _ in
                self?.viewModel.loadSavedArticles()
            }.store(in: &cancellables)
    }
}

extension SavedViewController: ArticlesViewDelegate {
    func didTapReloadButton() {
        viewModel.loadSavedArticles()
    }
}

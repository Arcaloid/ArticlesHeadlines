//
//  ArticlesViewController.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/8.
//

import UIKit
import Combine

protocol ArticlesViewDelegate: AnyObject {
    func didTapReloadButton()
}

final class ArticlesViewController: UIViewController, ActivityIndicatorShowable, ErrorRecoverble {
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let reloadButton = UIButton()
    private let viewModel: ArticlesViewModel
    private weak var delegate: ArticlesViewDelegate?
    private let tableView = UITableView()
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: ArticlesViewModel, delegate: ArticlesViewDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setSubscriptions()
    }
    
    private func setupView() {
        setupTableView()
        setupReloadButton()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.estimatedRowHeight = 200
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ArticleTableViewCell.self, forCellReuseIdentifier: ArticleTableViewCell.defaultReuseIdentifier)
        
        view.addSubview(tableView)
        tableView.constraintToSuperview()
    }
    
    private func setupReloadButton() {
        reloadButton.addTarget(self, action: #selector(didTapReloadButton), for: .touchUpInside)
    }
    
    @objc private func didTapReloadButton() {
        delegate?.didTapReloadButton()
    }
    
    private func setSubscriptions() {
        viewModel.stateSubject
            .receive(on: DispatchQueue.main)
            .sink { [weak self] in
                guard let self else { return }
                switch $0 {
                case .loading:
                    self.showIndicator()
                    self.hideReloadButton()
                    self.tableView.isHidden = true
                case .success:
                    self.hideIndicator()
                    self.hideReloadButton()
                    self.tableView.isHidden = false
                    self.tableView.reloadData()
                case let .error(message):
                    self.hideIndicator()
                    self.showError(message: message)
                    self.tableView.isHidden = true
                }
            }.store(in: &cancellables)
    }
}

extension ArticlesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let article = viewModel.articleAtIndex(indexPath.row),
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ArticleTableViewCell.defaultReuseIdentifier,
                for: indexPath
            ) as? ArticleTableViewCell
        else {
            return UITableViewCell()
        }
        
        cell.configure(article: article)
        return cell
    }
}

extension ArticlesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let article = viewModel.articleAtIndex(indexPath.row) else { return }
        let articleViewModel = ArticleViewModel(article: article)
        let articleViewController = ArticleViewController(viewModel: articleViewModel)
        navigationController?.pushViewController(articleViewController, animated: true)
    }
}

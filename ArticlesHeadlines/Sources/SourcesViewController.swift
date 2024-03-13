//
//  SourcesViewController.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import UIKit
import Combine

final class SourcesViewController: UIViewController, ActivityIndicatorShowable, ErrorRecoverble {
    let activityIndicator = UIActivityIndicatorView(style: .large)
    let reloadButton = UIButton()
    private let viewModel = SourcesViewModel()
    private let tableView = UITableView()
    private let cellIdentifier = "sourceCellIdentifier"
    private var cancellables = Set<AnyCancellable>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        setupView()
        viewModel.loadSources()
        setSubscriptions()
    }
    
    private func setupView() {
        setupTableView()
        setupReloadButton()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.isHidden = true
        tableView.estimatedRowHeight = 50
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
        view.addSubview(tableView)
        tableView.constraintToSuperview()
    }
    
    private func setupReloadButton() {
        reloadButton.addTarget(self, action: #selector(didTapReloadButton), for: .touchUpInside)
    }
    
    @objc private func didTapReloadButton() {
        viewModel.loadSources()
    }
    
    private func setSubscriptions() {
        viewModel.$state
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

extension SourcesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let source = viewModel.sourceAtIndex(indexPath.row) else { return UITableViewCell() }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) ?? UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        cell.selectionStyle = .none
        var config = cell.defaultContentConfiguration()
        config.text = source.name
        config.secondaryText = source.description
        cell.contentConfiguration = config
        cell.accessoryType = viewModel.isSourceSelected(atIndex: indexPath.row) ? .checkmark : .none
        return cell
    }
}

extension SourcesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        viewModel.didChangeSelectionAtIndex(indexPath.row)
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}

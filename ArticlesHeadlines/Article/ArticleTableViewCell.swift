//
//  ArticleTableViewCell.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import UIKit

class ArticleTableViewCell: UITableViewCell {
    private let articleImageView = UIImageView()
    private let titleLabel = UILabel()
    private let authorLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let standardPadding: CGFloat = 8
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }

    func configure(article: NewsArticle) {
        titleLabel.text = article.title
        authorLabel.text = "Author: \(article.author ?? "Unknown")"
        descriptionLabel.text = article.articleDescription
        // Keep simple for Demo purpose, in real project should use some cache mechanism
        if let imageUrl = article.urlToImage {
            articleImageView.load(url: imageUrl)
        }
    }

    private func setupViews() {
        contentView.backgroundColor = Color.defaultBackground.uiColor
        titleLabel.numberOfLines = 2
        descriptionLabel.numberOfLines = 4
        articleImageView.backgroundColor = Color.imageBackground.uiColor
        articleImageView.contentMode = .scaleAspectFill
        articleImageView.clipsToBounds = true
        articleImageView.layer.cornerRadius = 5
        
        addViewsAndConstraints()
    }
    
    private func addViewsAndConstraints() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(containerView)
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: standardPadding),
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: standardPadding),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -standardPadding)
        ])
        
        // Image
        articleImageView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(articleImageView)
        NSLayoutConstraint.activate([
            articleImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            articleImageView.topAnchor.constraint(equalTo: containerView.topAnchor),
            articleImageView.bottomAnchor.constraint(greaterThanOrEqualTo: containerView.bottomAnchor),
            articleImageView.widthAnchor.constraint(equalTo: articleImageView.heightAnchor),
            articleImageView.widthAnchor.constraint(equalToConstant: 80)
        ])
        
        // Title and Author
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        let titleStackView = UIStackView(arrangedSubviews: [titleLabel, authorLabel, UIView()])
        titleStackView.translatesAutoresizingMaskIntoConstraints = false
        titleStackView.axis = .vertical
        titleStackView.spacing = standardPadding
        
        containerView.addSubview(titleStackView)
        NSLayoutConstraint.activate([
            titleStackView.leadingAnchor.constraint(equalTo: articleImageView.trailingAnchor, constant: standardPadding),
            titleStackView.topAnchor.constraint(equalTo: containerView.topAnchor),
            titleStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),
            titleStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor)
        ])
        
        // Description
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(descriptionLabel)
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: containerView.bottomAnchor, constant: standardPadding),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -standardPadding)
        ])
    }
}

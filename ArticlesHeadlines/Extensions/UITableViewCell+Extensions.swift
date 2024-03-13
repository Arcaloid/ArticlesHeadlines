//
//  UITableViewCell+Extensions.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import UIKit

extension UITableViewCell {
    static var defaultReuseIdentifier: String {
        String(describing: Self.self)
    }
}

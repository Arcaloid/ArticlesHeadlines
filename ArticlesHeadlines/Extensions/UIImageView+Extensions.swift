//
//  UIImageView+Extensions.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import Foundation
import UIKit

extension UIImageView {
    func load(url: URL) {
        URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, _ in
            if let data = data {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.image = image
                }
            }
        }.resume()
    }
}

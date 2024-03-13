//
//  Color.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import UIKit

enum Color {
    case defaultBackground
    case imageBackground
    case defaultText
    
    var uiColor: UIColor {
        switch self {
        case .defaultBackground: return .white
        case .imageBackground: return .lightGray
        case .defaultText: return .darkText
        }
    }
}

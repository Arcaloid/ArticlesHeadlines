//
//  HomeTabBarViewModel.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/7.
//

import Foundation
import UIKit

struct HomeTabBarViewModel {
    enum Tab {
        case headlines, sources, saved
    }
    
    var tabs: [Tab] {
        [.headlines, .sources, .saved]
    }

    func viewController(forTab tab: Tab) -> UIViewController {
        switch tab {
        case .headlines: return HeadlinesViewController()
        case .sources: return SourcesViewController()
        case .saved: return SavedViewController()
        }
    }
    
    func tabBarItem(forTab tab: Tab) -> UITabBarItem {
        switch tab {
        case .headlines: 
            return UITabBarItem(
                title: "Headlines",
                image: UIImage(systemName: "newspaper"),
                selectedImage: UIImage(systemName: "newspaper.fill")
            )
        case .sources:
            return UITabBarItem(
                title: "Sources",
                image: UIImage(systemName: "checklist.unchecked"),
                selectedImage: UIImage(systemName: "checklist.checked")
            )
        case .saved:
            return UITabBarItem(
                title: "Saved",
                image: UIImage(systemName: "star"),
                selectedImage: UIImage(systemName: "star.fill")
            )
        }
    }
}

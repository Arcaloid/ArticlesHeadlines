//
//  HomeTabBarController.swift
//  ArticlesHeadlines
//
//  Created by Shan Chen on 2024/3/6.
//

import UIKit

class HomeTabBarController: UITabBarController {
    private let viewModel = HomeTabBarViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = Color.defaultBackground.uiColor
        setupTabBar()
    }
    
    private func setupTabBar() {
        tabBar.barTintColor = Color.defaultBackground.uiColor
        viewControllers = viewModel.tabs.map { tab in
            let viewController = viewModel.viewController(forTab: tab)
            let navigationController = UINavigationController(rootViewController: viewController)
            navigationController.tabBarItem = viewModel.tabBarItem(forTab: tab)
            return navigationController
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

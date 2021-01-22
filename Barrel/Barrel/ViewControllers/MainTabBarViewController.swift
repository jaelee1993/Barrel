//
//  MainTabBarViewController.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit


class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViewControllers()
    }
    

    func setupViewControllers() {
         let splitViewController = CustomSplitViewController()
         splitViewController.preferredDisplayMode = .allVisible
         
         
        
        
        let homeViewController = HomeViewController()
        let homeViewControllerNavigation = UINavigationController(rootViewController: homeViewController)
        homeViewControllerNavigation.navigationBar.prefersLargeTitles = true
        homeViewController.customeSplitViewController = splitViewController
        
        
        let spotDetailViewController = SpotDetailViewController()
        spotDetailViewController.spot = Spot()
        
        
        splitViewController.viewControllers = [homeViewControllerNavigation, spotDetailViewController]
        
    
        
        
        viewControllers = [
            splitViewController,
        ]
        
        
        
        
        let modalStyle: UIModalTransitionStyle = UIModalTransitionStyle.crossDissolve
        modalTransitionStyle = modalStyle
    }

}

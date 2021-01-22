//
//  CustomSplitViewController.swift
//  Barrel
//
//  Created by Jae Lee on 8/12/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit

class CustomSplitViewController: UISplitViewController, UISplitViewControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    

    func splitViewController(_ splitViewController: UISplitViewController, collapseSecondary secondaryViewController: UIViewController, onto primaryViewController: UIViewController) -> Bool {
        return true
    }
    
    
}

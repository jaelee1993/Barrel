//
//  TableView.swift
//  Barrel
//
//  Created by Jae Lee on 7/24/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit
//MARK: - TableViewCell
extension UITableViewCell {
    func removeSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: self.bounds.width + 5000)
    }
    func showSeparator() {
        self.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 0)
    }
}

//MARK: - TableView
extension UITableView {
    func createParallaxTableViewHeader(_ parentView:UIView, mainHeaderView:UIView, height:CGFloat) {
        // setting tableView inset and offsets
        contentInset = UIEdgeInsets(top: height, left: 0, bottom: 0, right: 0)
        contentOffset = CGPoint(x: 0, y: -height)
        
        // this is the main background view
        let superTableViewBackground = UIView()
        superTableViewBackground.backgroundColor = .hetro_white
               
        // adding main header view to superTableView
        superTableViewBackground.addSubview(mainHeaderView)
        
        // setting tableView.backgroundView as superTableViewBackground
        backgroundView = superTableViewBackground
        
        mainHeaderView.translatesAutoresizingMaskIntoConstraints = false
        
        if #available(iOS 11.0, *) {
            NSLayoutConstraint.activate([
                mainHeaderView.leadingAnchor.constraint(equalTo: leadingAnchor),
                mainHeaderView.trailingAnchor.constraint(equalTo: backgroundView!.trailingAnchor),
                mainHeaderView.heightAnchor.constraint(equalToConstant: height * 20),
                mainHeaderView.bottomAnchor.constraint(equalTo: contentLayoutGuide.topAnchor),
                ])
        } else {
            // Fallback on earlier versions
            // This is handled in the tableView cellForRowAt function
        }
        
        tableFooterView = UIView()
    }
}

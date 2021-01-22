//
//  TagTitleCollectionViewCell.swift
//  Aphrodite
//
//  Created by Jae Lee on 8/26/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit

class TagTitleCollectionViewCell: UICollectionViewCell {
    var tab:UIView!
    var title: UILabel!
    var identifier:String = ""
    
    var customIsSelected: Bool = false {
        didSet {
            UIView.animate(withDuration: 0.3) {
                if self.customIsSelected {
                    if #available(iOS 13.0, *) {
                        if self.traitCollection.userInterfaceStyle == .dark {
                            self.backgroundColor = UIColor.hetro_black.withAlphaComponent(0.9)
                       } else {
                        self.backgroundColor = .hetro_systemGray4
                       }
                    } else {
                        self.backgroundColor = .hetro_systemGray4
                    }
                    
                    self.title.textColor = .hetro_white
                } else {
                    self.backgroundColor = .hetro_white
                    self.title.textColor = .hetro_black
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        roundAllCorners(radius: 5)
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        setup()
    }
    deinit {
        NotificationCenter.default.removeObserver(self,
                                                  name: Notification.Name(TextContent.TagHit.name),
                                                  object: nil)
    }
       
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate func setup() {
        addObservers()
        setupTab()
        setupTitle()
    }
    
    fileprivate func addObservers() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.cellSelected(notification:)),
                                               name: Notification.Name(TextContent.TagHit.name),
                                                object: nil)
        
    }
    @objc func cellSelected(notification: NSNotification) {
        if let identifier = notification.userInfo?[TextContent.TagHit.key] as? String {
            if self.identifier == identifier {
                customIsSelected.toggle()
            } else {
                customIsSelected = false
            }
        } else {
            customIsSelected = false
        }
    }
       
    fileprivate func setupTab() {
        tab = UIView()
        tab.backgroundColor = .systemGreen
        tab.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(tab)
        NSLayoutConstraint.activate([
            tab.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            tab.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            tab.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -0),
            tab.heightAnchor.constraint(greaterThanOrEqualToConstant: 16),
            tab.widthAnchor.constraint(equalToConstant: 10)
        ])
        
        
    }
    
    fileprivate func setupTitle() {
        title = UILabel()
        title.numberOfLines = 1
        title.textAlignment = .center
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 12, weight: .light)
        title.textColor = .hetro_black
        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: tab.trailingAnchor, constant: 3),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 2),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -2),
            title.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            title.heightAnchor.constraint(greaterThanOrEqualToConstant: 14),
            title.widthAnchor.constraint(lessThanOrEqualToConstant: 140)
        ])
    }
    
    
}


//
//  StatCollectionViewCell.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit



/**
 Styling object for **StatCollectionViewCell**
 ## Properties
 - title:String
 - body:String
 - bodyFont:UIFont | Defaults to SystemFont.bold of size 14
 - bodyColor:UIColor | Defaults to black
 */
struct Statistic {
    var title:String
    var body:String
    var titleFont:UIFont?
    var bodyFont:UIFont?
    var bodyColor:UIColor?
    var bodyBackgroundColor:UIColor?
    var customBodyView:UIView?
    
    init(title:String, body:String, bodyFont:UIFont? = UIFont.systemFont(ofSize: 20, weight: .regular), bodyColor:UIColor? = .hetro_labelColor, titleFont:UIFont? = UIFont.systemFont(ofSize: 13, weight: .regular), bodyBackgroundColor:UIColor? = .hetro_white) {
        self.title = title
        self.body = body
        self.bodyFont = bodyFont
        self.bodyColor = bodyColor
        self.titleFont = titleFont
        self.bodyBackgroundColor = bodyBackgroundColor
    
    }
    
}

class StatCollectionViewCell: UICollectionViewCell {
    var title:UILabel!
    var mainViewContainer:UIView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTitleLabel()
        
        setupMainView()
        
    }
    
 
    fileprivate func setupTitleLabel() {
        title = UILabel()
        title.textColor = .gray
        title.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.heightAnchor.constraint(equalToConstant: 20),
            title.topAnchor.constraint(equalTo: self.topAnchor, constant: 5),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: self.trailingAnchor)
            ])
    }
    
    fileprivate func setupMainView() {
        mainViewContainer = UIView()
        mainViewContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainViewContainer)
        NSLayoutConstraint.activate([
            mainViewContainer.topAnchor.constraint(equalTo: self.title.bottomAnchor),
            mainViewContainer.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            mainViewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainViewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 5),
            ])
    }
    
 
    fileprivate func addContentView(_ contentView: UIView) {
        mainViewContainer.subviews.forEach({ $0.removeFromSuperview() })
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mainViewContainer.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: mainViewContainer.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainViewContainer.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainViewContainer.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainViewContainer.bottomAnchor),
            ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(_ title:String, _ contentView:UIView) {
        self.title.text = title
        addContentView(contentView)

    }
    
    
    
    
}

class StatStyleTwoCollectionViewCell: UICollectionViewCell {
    var title:UILabel!
    var mainViewContainer:UIView!

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupTitleLabel()
        
        setupMainView()
        
    }
    
 
    fileprivate func setupTitleLabel() {
        title = UILabel()
        title.textColor = .gray
        title.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        title.translatesAutoresizingMaskIntoConstraints = false
        addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: self.topAnchor),
            title.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            title.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            title.widthAnchor.constraint(equalToConstant: self.bounds.width * 3/4)
            ])
    }
    
    fileprivate func setupMainView() {
        mainViewContainer = UIView()
        mainViewContainer.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainViewContainer)
        NSLayoutConstraint.activate([
            mainViewContainer.topAnchor.constraint(equalTo: self.topAnchor),
            mainViewContainer.leadingAnchor.constraint(equalTo: title.trailingAnchor),
            mainViewContainer.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            mainViewContainer.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
    }
    
 
    fileprivate func addContentView(_ contentView: UIView) {
        mainViewContainer.subviews.forEach({ $0.removeFromSuperview() })
        
        contentView.translatesAutoresizingMaskIntoConstraints = false
        mainViewContainer.addSubview(contentView)
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: mainViewContainer.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: mainViewContainer.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: mainViewContainer.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: mainViewContainer.bottomAnchor),
            ])
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func configure(_ title:String, _ contentView:UIView) {
        self.title.text = title
        addContentView(contentView)

    }
    
    
    
    
}

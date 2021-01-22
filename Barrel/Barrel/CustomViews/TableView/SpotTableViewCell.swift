//
//  SpotTableViewCell.swift
//  Barrel
//
//  Created by Jae Lee on 8/24/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit

class SpotTableViewCell: UITableViewCell {
    var title:UILabel!
    var height:UILabel!
    var condition:UILabel!
    var backgroundImageView:UIImageView!
    var iconImageView:UIImageView!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        setupBackgroundImageView()
        setupIconImageView()
        setupTitle()
        setupCondition()
        setupHeight()
    }
    
    fileprivate func setupBackgroundImageView() {
        backgroundImageView = UIImageView()
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backgroundImageView)
        backgroundImageView.constraintsToSuperView(contentView)
    }
    
    
    fileprivate func setupIconImageView() {
        iconImageView = UIImageView()
        iconImageView.isHidden = true
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        iconImageView.contentMode = .scaleAspectFit
        contentView.addSubview(iconImageView)
        NSLayoutConstraint.activate([
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            iconImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            iconImageView.heightAnchor.constraint(equalToConstant: 20),
            iconImageView.widthAnchor.constraint(equalToConstant: 20),
        ])
    }
    fileprivate func setupTitle() {
        title = UILabel()
        title.text = "N/A"
        title.translatesAutoresizingMaskIntoConstraints = false
        title.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        contentView.addSubview(title)
        NSLayoutConstraint.activate([
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            title.heightAnchor.constraint(equalToConstant: 20),
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            title.trailingAnchor.constraint(equalTo: iconImageView.leadingAnchor),
        ])
    }
    fileprivate func setupCondition() {
        condition = UILabel()
        condition.text = "N/A"
        condition.backgroundColor = .oceanBlue
        condition.textColor = .white
        condition.translatesAutoresizingMaskIntoConstraints = false
        condition.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        contentView.addSubview(condition)
        NSLayoutConstraint.activate([
            condition.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            condition.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 3),
            condition.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10),
            condition.widthAnchor.constraint(greaterThanOrEqualToConstant: 30),
            condition.heightAnchor.constraint(equalToConstant: 20),
        ])
    
    }
    fileprivate func setupHeight() {
        height = UILabel()
        height.text = "LOLA"
        height.translatesAutoresizingMaskIntoConstraints = false
        height.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        contentView.addSubview(height)
        NSLayoutConstraint.activate([
            height.topAnchor.constraint(equalTo: condition.topAnchor),
            height.bottomAnchor.constraint(equalTo: condition.bottomAnchor),
            height.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            height.heightAnchor.constraint(equalTo:condition.heightAnchor),
        ])
        
    }

    
    func setIconImageView(image:UIImage? = nil) {
        iconImageView.isHidden = false
        iconImageView.image = image
    }
}

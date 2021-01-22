//
//  BarGraphCollectionViewCell.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//
import UIKit

class BarGraphCollectionViewCell: UICollectionViewCell {
    var value:Double = 0
    var bar:UIView!
    var title:UILabel!
    var subTitle:UILabel!
    var subTitleHeight:CGFloat = 20
    
    var barHeightAnchor:NSLayoutConstraint!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white.withAlphaComponent(0.0)
        setup()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    fileprivate func setup() {
        setupSubTitle()
        setupBar()
        setupTitle()
    }
    fileprivate func setupBar() {
        bar = UIView()
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.backgroundColor = .oceanBlue
        bar.roundAllCorners(radius: 5)
        contentView.addSubview(bar)
        barHeightAnchor = bar.heightAnchor.constraint(equalToConstant: frame.height - subTitleHeight)
        NSLayoutConstraint.activate([
            bar.bottomAnchor.constraint(equalTo: subTitle.topAnchor),
            bar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            bar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            barHeightAnchor
        ])
    }
    fileprivate func setupTitle() {
        title = UILabel()
        title.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(title)
        NSLayoutConstraint.activate([
            title.bottomAnchor.constraint(equalTo: subTitle.topAnchor),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            title.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    fileprivate func setupSubTitle() {
        subTitle = UILabel()
        subTitle.text = "N/A"
        subTitle.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
        subTitle.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(subTitle)
        NSLayoutConstraint.activate([
            subTitle.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            subTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            subTitle.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            subTitle.heightAnchor.constraint(equalToConstant: subTitleHeight)
        ])
    }
    
    
    func configure(value:Double) {
        self.value = value
        UIView.animate(withDuration: 0.3) {
            self.barHeightAnchor.constant = self.frame.height * CGFloat(self.value)
            self.layoutIfNeeded()
        }
    }
    func configure(title:String) {
        self.title.text = title
    }
    func configure(subTitle:String) {
        self.subTitle.text = subTitle
    }
}

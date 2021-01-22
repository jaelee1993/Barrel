//
//  XColumnStatsTableViewCell.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit

class XColumnStatsTableViewCell: UITableViewCell {
    var collectionView:UICollectionView!
    var statistics:[Statistic] = []
    
    let padding:CGFloat = 20
    let itemSpacing:CGFloat = 10
    
    private func collectionViewSetup() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.sectionInset = .init(top: 0, left: padding, bottom: 0, right: padding)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = itemSpacing
        
        collectionView = UICollectionView(frame: contentView.frame, collectionViewLayout: flowLayout)
        collectionView.clipsToBounds = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .hetro_white
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(StatCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(StatCollectionViewCell.self))
        
        contentView.addSubview(collectionView)
        
        collectionView.constraintsToSuperView(contentView)
    }
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor.hetro_white
        collectionViewSetup()
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(_ statistics:[Statistic]) {
        self.statistics = statistics
        collectionView.reloadData()
    }
    
    
}

extension XColumnStatsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return statistics.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier:  NSStringFromClass(StatCollectionViewCell.self), for: indexPath) as! StatCollectionViewCell
        let label = UILabel()
        label.text = statistics[indexPath.row].body
        label.font = statistics[indexPath.row].bodyFont
        label.textColor = statistics[indexPath.row].bodyColor
        
        
        if let customBodyView = statistics[indexPath.row].customBodyView {
            cell.configure(statistics[indexPath.row].title, customBodyView)
        }
        else {
            cell.configure(statistics[indexPath.row].title, label)
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}

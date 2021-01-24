//
//  CarouselTagTableViewCell.swift
//  Aphrodite
//
//  Created by Jae Lee on 8/28/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit
protocol TagDelegate {
    func tagSelected(_ tag:Tag)
    var currentlySelectedTag:Tag? {get set}
}


class CarouselTagTableViewCell: UITableViewCell {
    fileprivate var collectionView:UICollectionView!
    var tagDelegate:TagDelegate?
    var tags:[Tag] = [Tag()]
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    fileprivate func setup() {
        collectionViewSetup()
    }
    private func collectionViewSetup() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: contentView.frame, collectionViewLayout: flowLayout)
        collectionView.clipsToBounds = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .hetro_white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
        collectionView.register(TagTitleCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(TagTitleCollectionViewCell.self))
        
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor)
            ])
    }
    public func configure(tags:[Tag]) {
        self.tags = tags
        collectionView.reloadData()
    }
}


extension CarouselTagTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tags.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(TagTitleCollectionViewCell.self), for: indexPath) as! TagTitleCollectionViewCell
        let tag = tags[indexPath.row]
        if let tagName = tag.tagName {
            cell.identifier = tagName
            if let currentlySelectedTag = tagDelegate?.currentlySelectedTag, let currentlySelectedTagName = currentlySelectedTag.tagName  {
                cell.customIsSelected = (currentlySelectedTagName == tagName)
            } else {
                cell.customIsSelected = false
            }
        }
        if let name = tag.displayName {
            cell.title.text = name
        }
        if let color = tag.color {
            cell.tab.backgroundColor = UIColor.getColorByLiteralName(color)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let tag = tags[indexPath.row]
        if let displayName = tag.displayName {
            let name = displayName as NSString
            let size = name.size(withAttributes: nil)
            return CGSize(width: size.width + 32 , height: collectionView.frame.height - 10)
            
        } else {
            return CGSize(width: 10, height: collectionView.frame.height - 10)
        }
        
       
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        tagDelegate?.tagSelected(tags[indexPath.row])
    }
    
}

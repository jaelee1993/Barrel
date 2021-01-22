//
//  BarGraph.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit


class BarCell {
    var name:String = ""
    var multiplier:Double = 0.0
    var otherData:[String:Any] = [:]
    init(name:String, multiplier:Double) {
        self.name = name
        self.multiplier = multiplier
    }
}

class BarGraph: UIView {
    var collectionView:UICollectionView!
    var cells:[BarCell] = [BarCell(name: "1", multiplier: 0.2),
                           BarCell(name: "1", multiplier: 0.4),
                           BarCell(name: "1", multiplier: 0.6),
                           BarCell(name: "1", multiplier: 0.8),
                           BarCell(name: "1", multiplier: 0.7)] {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    fileprivate func setup() {
        setupCollectionView()
    }
    
    fileprivate func setupCollectionView() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(BarGraphCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(BarGraphCollectionViewCell.self))
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
}





extension BarGraph: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cells.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(BarGraphCollectionViewCell.self), for: indexPath) as! BarGraphCollectionViewCell
        cell.configure(value: cells[indexPath.row].multiplier)
        cell.configure(title: cells[indexPath.row].name)
        if let timestamp = cells[indexPath.row].otherData["timestamp"] as? Int {
            let date = timestamp.convertUnixToDate()
            let time = DateService.convertDate(date, format: DateService.F101)
            cell.configure(subTitle: time)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width/CGFloat(cells.count) - 5), height: collectionView.frame.height)
    }
}

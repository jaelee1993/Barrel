//
//  CarouselForcastDataView.swift
//  Barrel
//
//  Created by Jae Lee on 8/16/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import UIKit

class CarouselForcastDataView: UIView {
    var collectionView:UICollectionView!
    var dataSource:ForcastDataDelegate? {
        didSet {
            collectionView.reloadData()
        }
    }
    
    
    init() {
        super.init(frame: CGRect())
        setup()
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setup() {
        collectionViewSetup()
        setupObservers()
    }
    private func setupObservers() {
        NotificationCenter.default.addObserver(self,
        selector: #selector(self.scrollTo(_:)),
        name: Notification.Name(TextContent.SurfDataSegmentHit.name),
        object: nil)
    }
    
   
    @objc func scrollTo(_ notification: NSNotification) {
        if let index = notification.userInfo?[TextContent.SurfDataSegmentHit.indexKey] as? Int {
            collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    private func collectionViewSetup() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .init(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: flowLayout)
        collectionView.clipsToBounds = false
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.showsHorizontalScrollIndicator = true
        collectionView.showsVerticalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.isScrollEnabled = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .hetro_white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(UICollectionViewCell.self))
        collectionView.register(SurfDataCollectionViewCell.self, forCellWithReuseIdentifier: NSStringFromClass(SurfDataCollectionViewCell.self))
        
        addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: bottomAnchor),
            collectionView.topAnchor.constraint(equalTo: topAnchor)
            ])
        
    }
    
    
    

}


extension CarouselForcastDataView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let segmentCount = dataSource?.segments.count {
            return segmentCount
        }
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(SurfDataCollectionViewCell.self), for: indexPath) as! SurfDataCollectionViewCell
        if let segments = dataSource?.segments {
            let segment = segments[indexPath.row]
            if let tides = dataSource?.tideOverview?.data?.tides?.getContentSeparatedByTimestamp()[segment] as? [Tide],
                let wind = dataSource?.windOverview?.data?.wind?.getContentSeparatedByTimestamp()[segment] as? [Wind],
                let wave = dataSource?.waveOverview?.data?.wave?.getContentSeparatedByTimestamp()[segment] as? [Wave] {
                cell.surfDataView.configure(tides: tides, wind: wind, wave: wave)
            }
        }
        
       
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            return CGSize(width: collectionView.frame.width, height: 700)
        case .phone:
            return CGSize(width: collectionView.frame.width, height: 700)
        default:
            return CGSize(width: collectionView.frame.width, height: 700)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    }
    
}




extension CarouselForcastDataView: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        post(index: index)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
        post(index: index)
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let index = round(scrollView.contentOffset.x/frame.width)
        post(index: Int(index))
        
    }
    func post(index:Int) {
        NotificationCenter.default.post(name: Notification.Name(TextContent.SurfDataCarouselScrolled.name),
                                        object: nil,
                                        userInfo: [TextContent.SurfDataCarouselScrolled.indexKey:index] )
    }
}


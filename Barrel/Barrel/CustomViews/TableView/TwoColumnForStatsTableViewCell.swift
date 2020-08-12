//
//  TwoColumnForStatsTableViewCell.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit

class TwoColumnForStatsTableViewCell: XColumnStatsTableViewCell {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rowCount:CGFloat = CGFloat(ceil(Double(statistics.count)/2))
        
        return CGSize(width: (contentView.frame.width/2) - padding - itemSpacing, height: contentView.frame.height/rowCount)
    }
  
}

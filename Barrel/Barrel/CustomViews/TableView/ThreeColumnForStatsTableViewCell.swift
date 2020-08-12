//
//  ThreeColumnForStatsTableViewCell.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit

class ThreeColumnForStatsTableViewCell: XColumnStatsTableViewCell {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rowCount:CGFloat = CGFloat(ceil(Double(statistics.count)/3))
        return CGSize(width: (contentView.frame.width/3) - padding - itemSpacing, height: contentView.frame.height/rowCount)
    }
}

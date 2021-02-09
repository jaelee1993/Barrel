//
//  HomeViewModel.swift
//  Barrel
//
//  Created by Jae Lee on 2/9/21.
//  Copyright © 2021 Jae Lee. All rights reserved.
//

import Foundation
import Combine

struct HomeViewModel {
    
    @objc fileprivate func getData(currentlySelectedTag:Tag) {
        guard let selectedSubRegion = currentlySelectedTag.description else {return}
        
        API.getSubRegionOverview(subRegionId: <#T##String#>, completion: <#T##(Overview?) -> Void#>)
        API.getSubRegionOverview(subRegionId: selectedSubRegion) { (overview) in
            if let overview = overview {
                self.overview = overview
                
            }
        }
    }
}

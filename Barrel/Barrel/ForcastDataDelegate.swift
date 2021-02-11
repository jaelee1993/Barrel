//
//  ForcastDataDelegate.swift
//  Barrel
//
//  Created by Jae Lee on 2/11/21.
//  Copyright © 2021 Jae Lee. All rights reserved.
//

import Foundation

protocol ForcastDataDelegate {
    var tideOverview:Overview? {get set}
    var windOverview:Overview? {get set}
    var waveOverview:Overview? {get set}
    var currentSelectedDate:String {get set}
    var segments:[String] {get set}
}

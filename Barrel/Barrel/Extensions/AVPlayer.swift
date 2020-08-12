//
//  AVPlayer.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

extension AVPlayer {
    func getDurationOfCurrentItem() -> Float64? {
        let duration = self.currentItem?.duration
        if let durationInSeconds = duration?.convertScale(CMTimeScale(exactly: 1)!, method: CMTimeRoundingMethod.default) {
            return CMTimeGetSeconds(durationInSeconds)
        } else {
            return nil
        }
    }
    
    
    func getCurrentItemCurrentTime() -> Float64? {
        let currentTime = self.currentItem?.currentTime()
        if let currentTimeInSeconds = currentTime?.convertScale(CMTimeScale(exactly: 1)!, method: CMTimeRoundingMethod.default) {
            return CMTimeGetSeconds(currentTimeInSeconds)
        } else {
            return nil
        }
    }
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
    
   
}

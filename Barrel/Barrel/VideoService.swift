//
//  VideoService.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import AVFoundation
import AVKit

class VideoService {
    public static func playVideo(parentVC: UIViewController, videoUrl:URL? = nil, localPath:String? = nil, playerStartTime:CMTime?, audioMixedWithOthers:Bool = false) {
        let session = AVAudioSession.sharedInstance()
        
        var url:URL
        if let localPath = localPath {
            url = URL(fileURLWithPath: localPath)
        } else if let videoUrl = videoUrl {
            url = videoUrl
        }
        else {
            return
        }
        let player = AVPlayer(url: url)
        if let playerStartTime = playerStartTime {
            player.seek(to: playerStartTime)
        }
        
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        player.isMuted = true
        parentVC.present(playerViewController, animated: true) {
            if audioMixedWithOthers {
                try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)
                do {
                    try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: .mixWithOthers)
                    try AVAudioSession.sharedInstance().setActive(true)
                } catch {
                    print(error)
                }
            }
            playerViewController.player!.play()
        }
    }
    
}

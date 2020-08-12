//
//  VideoTableViewCell.swift
//  Barrel
//
//  Created by Jae Lee on 7/22/20.
//  Copyright © 2020 Jae Lee. All rights reserved.
//

import Foundation
import UIKit
import AVKit

class VideoTableViewCell: UITableViewCell {
    var parentViewController:               UIViewController?
    var playerContentView:                  UIView!
    var videoGradientLayer:                 CAGradientLayer?
    var player:                             AVPlayer = AVPlayer()
    var playerLayer:                        AVPlayerLayer?
    var playerItem:                         AVPlayerItem?
    var controlButton:                      UIButton!
    var controlButtonImageView:             UIImageView!
    var soundButton:                        UIButton!
    var fullScreenButton:                   UIButton!
    
    var contentViewtopAnchor:               NSLayoutConstraint!
    var contentViewbottomAnchor:            NSLayoutConstraint!
    var contentViewleadingAnchor:           NSLayoutConstraint!
    var contentViewtrailingAnchor:          NSLayoutConstraint!
    
    
    var videoUrl:                           URL?
    var playerDidFinishPlayingValue:        Bool = false
    
    let pauseImage:                         String = "ic_pauseButton"
    let playImage:                          String = "ic_playButton"

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerLayer?.frame = self.playerContentView.frame
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup() {
        addObservers()
        setupPlayerContentView()
        setupPlayerView()
        setupControlButton()
        setupFullScreenButton()
    }
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "closeVideoPlayer"), object: nil)
    }
    fileprivate func addObservers() {
          NotificationCenter.default.addObserver(self, selector: #selector(self.closeVideoPlayer), name: NSNotification.Name(rawValue: "closeVideoPlayer"), object: nil)
    }
    fileprivate func setupPlayerContentView() {
        playerContentView = UIView()
        playerContentView.translatesAutoresizingMaskIntoConstraints = false
        playerContentView.backgroundColor = .black
        contentView.addSubview(playerContentView)
        
        contentViewtopAnchor       = playerContentView.topAnchor.constraint(equalTo: contentView.topAnchor)
        contentViewbottomAnchor    = playerContentView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        contentViewleadingAnchor   = playerContentView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor)
        contentViewtrailingAnchor  = playerContentView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        
        NSLayoutConstraint.activate([
            contentViewtopAnchor,
            contentViewbottomAnchor,
            contentViewleadingAnchor,
            contentViewtrailingAnchor,
            contentView.heightAnchor.constraint(equalToConstant: 200)
        
        ])

    }
    
    fileprivate func setupPlayerView() {
        let session = AVAudioSession.sharedInstance()
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        self.player.isMuted = true
        self.player.addObserver(self, forKeyPath: "timeControlStatus", options: [.old, .new], context: nil)
        self.playerLayer = AVPlayerLayer(player: self.player)
        self.playerLayer?.videoGravity = .resizeAspectFill
        self.playerLayer?.frame = self.playerContentView.frame
        self.playerLayer?.isHidden = false
        self.playerContentView?.layer.addSublayer(playerLayer!)
        self.layoutIfNeeded()
    }
    
    @objc func playerDidFinishPlaying() {
        self.controlButtonImageView.alpha = 1
        controlButtonImageView.image = UIImage(named: playImage)
        playerDidFinishPlayingValue = true
    }
    
    func playVideo() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: .mixWithOthers)
             try AVAudioSession.sharedInstance().setActive(true)
        } catch {
             print(error)
        }
        self.controlButtonImageView.alpha = 1
        self.player.automaticallyWaitsToMinimizeStalling = false
        self.player.play()
        controlButtonImageView.image = UIImage(named: pauseImage)
        UIView.animate(withDuration: 2.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.controlButtonImageView.alpha = 0
        }) { (_) in
        }
    }
    func pauseVideo() {
        self.controlButtonImageView.alpha = 1
        self.player.pause()
        controlButtonImageView.image = UIImage(named: playImage)
        UIView.animate(withDuration: 2.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.controlButtonImageView.alpha = 0
        }) { (_) in
        }
    }
    
    
    
    
    fileprivate func setupControlButton() {
        controlButtonImageView = UIImageView()
        controlButtonImageView.translatesAutoresizingMaskIntoConstraints = false
        controlButtonImageView.contentMode = .scaleAspectFit
        playerContentView.addSubview(controlButtonImageView)
        controlButtonImageView.constraintsToSuperView(playerContentView)
        
        controlButton = UIButton()
        controlButton.translatesAutoresizingMaskIntoConstraints = false
        controlButton.imageView?.contentMode = .scaleAspectFit
        controlButton.addTarget(self, action: #selector(toggleVideoControl), for: .touchUpInside)
        playerContentView.addSubview(controlButton)
        controlButton.constraintsToSuperView(playerContentView)
        
        setupSoundButton()
    }
    
    
    fileprivate func setupSoundButton() {
        soundButton = UIButton()
        soundButton.addTarget(self, action: #selector(toggleSound), for: .touchUpInside)
        soundButton.translatesAutoresizingMaskIntoConstraints = false
        if player.isMuted {
            soundButton.setImage(UIImage(named: "speaker_crossed_WHT"), for: .normal)
        } else {
            soundButton.setImage(UIImage(named: "speaker_WHT"), for: .normal)
        }
        playerContentView.addSubview(soundButton)
        
        NSLayoutConstraint.activate([
            soundButton.heightAnchor.constraint(equalToConstant: 30),
            soundButton.widthAnchor.constraint(equalToConstant: 30),
            soundButton.bottomAnchor.constraint(equalTo: playerContentView.bottomAnchor, constant: -5),
            soundButton.trailingAnchor.constraint(equalTo: playerContentView.trailingAnchor, constant: -10),
        ])
    }
    
    
    
    fileprivate func setupFullScreenButton() {
        fullScreenButton = UIButton()
        fullScreenButton.addTarget(self, action: #selector(goFullScreen), for: .touchUpInside)
        fullScreenButton.translatesAutoresizingMaskIntoConstraints = false
        fullScreenButton.setImage(UIImage(named: "fullScreen"), for: .normal)
        playerContentView.addSubview(fullScreenButton)
        
        NSLayoutConstraint.activate([
            fullScreenButton.heightAnchor.constraint(equalToConstant: 30),
            fullScreenButton.widthAnchor.constraint(equalToConstant: 30),
            fullScreenButton.bottomAnchor.constraint(equalTo: playerContentView.bottomAnchor, constant: -5),
            fullScreenButton.trailingAnchor.constraint(equalTo: soundButton.leadingAnchor, constant: -10),
        ])
    }
    
    @objc func toggleVideoControl() {
        if player.isPlaying {
            pauseVideo()
        } else {
            if playerDidFinishPlayingValue {
                self.player.seek(to: CMTime.zero)
                self.playerDidFinishPlayingValue = false
                playVideo()
            } else {
                playVideo()
            }
        }
    }
    
    @objc func toggleSound() {
        if player.isMuted {
            unMuteSound()
        } else {
            muteSound()
        }
    }
    
    @objc func goFullScreen() {
        if let videoUrl = videoUrl, let vc = parentViewController  {
            let time = player.currentTime()
            VideoService.playVideo(parentVC: vc, videoUrl: videoUrl, localPath: nil, playerStartTime: time, audioMixedWithOthers:true)
        }
        
    }
    
    @objc func closeVideoPlayer() {
        self.pauseVideo()
        self.playerItem = nil
    }
    
    
    func muteSound() {
        soundButton.setImage(UIImage(named: "speaker_crossed_WHT"), for: .normal)
        player.isMuted = true
    }
    
    func unMuteSound() {
        soundButton.setImage(UIImage(named: "speaker_WHT"), for: .normal)
        player.isMuted = false
    }
    
    
    private func replaceCurrentPlayerItem() {
        if let url = self.videoUrl {
            DispatchQueue.main.async {
                self.playerItem = AVPlayerItem(url: url )
                self.player.replaceCurrentItem(with: self.playerItem)
                self.playerDidFinishPlayingValue = false
                self.playVideo()
            }
        }
    }
    func configure(urlString:String, parentViewController:UIViewController) {
        self.videoUrl = URL(string: urlString)
        self.parentViewController = parentViewController
        replaceCurrentPlayerItem()
    }
    
    func configure(url:URL, parentViewController:UIViewController) {
        self.videoUrl = url
        self.parentViewController = parentViewController
        self.playerItem = AVPlayerItem(url: url )
        self.player.replaceCurrentItem(with: self.playerItem)
        self.playerDidFinishPlayingValue = false
        playVideo()
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if let avPlayer = object as? AVPlayer {
            if #available(iOS 10.0, *) {
                switch avPlayer.timeControlStatus {
                case .playing:
                    print("playing")
                    
                    
                case .paused:
                    print("paused")
                    
                case .waitingToPlayAtSpecifiedRate:
                    print("waitingToPlayAtSpecifiedRate")
                    print(player.reasonForWaitingToPlay?.rawValue)
                @unknown default:
                    print("other")
                }
                
            }
        }
        
    }
}


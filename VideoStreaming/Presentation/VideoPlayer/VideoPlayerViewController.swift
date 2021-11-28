//
//  VideoPlayerViewController.swift
//  VideoStreaming
//
//  Created by Niroshan Maheswaran on 28.11.21.
//

import UIKit
import AVKit

enum VideoPlayerImages: String {
    case play = "play.fill"
    case pause = "pause.fill"
}

extension AVPlayer {
    
    /// Returns true if player is playing video.
    var isPlaying: Bool {
        rate != 0 && error == nil
    }
}

class VideoPlayerViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet private weak var playerView: UIView!
    @IBOutlet private weak var playPauseButton: UIButton!
    
    // MARK: - Public properties
    
    public var video: Video?
    
    // MARK: - Private properties
    
    private var player: AVPlayer?
    private var playerLayer: AVPlayerLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        title = video?.title
        
        subscribeToPlayerNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupPlayer()
        setupVideo()
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: nil) { [unowned self] _ in
            self.playerLayer?.frame = view.bounds
        }
    }
}

// MARK: - Private methods

private extension VideoPlayerViewController {
    
    func setupPlayer() {
        playerLayer?.removeFromSuperlayer()
        
        player = AVPlayer()
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = view.bounds
        playerLayer?.videoGravity = .resizeAspect
        
        playerView.backgroundColor = .clear
        playerView.layer.addSublayer(playerLayer!)
        
        playPauseButton.setTitle(nil, for: .normal)
        playPauseButton.tintColor = .orange
        playPauseButton.setImage(UIImage(systemName: VideoPlayerImages.play.rawValue), for: .normal)
        playPauseButton.addTarget(
            self,
            action: #selector(togglePlayPause),
            for: .touchUpInside
        )
    }
    
    func setupVideo() {
        var playerItem: AVPlayerItem
        
        if let remoteURL = video?.remoteVideoURL {
            playerItem = AVPlayerItem(url: remoteURL)
        } else if let localURL = video?.localVideoURL {
            playerItem = AVPlayerItem(url: localURL)
        } else {
            preconditionFailure("Invalid video.")
        }
        
        player?.replaceCurrentItem(with: playerItem)
    }
    
    func subscribeToPlayerNotifications() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(playerFinishedVideo),
            name: .AVPlayerItemDidPlayToEndTime,
            object: nil
        )
    }
    
    @objc private func playerFinishedVideo() {
        setupVideo()
        playPauseButton.setImage(
            UIImage(systemName: VideoPlayerImages.play.rawValue),
            for: .normal
        )
    }
    
    @objc private func togglePlayPause() {
        if player!.isPlaying {
            player!.pause()
        } else {
            player!.play()
        }
        
        playPauseButton.setImage(
            UIImage(systemName: player!.isPlaying ? VideoPlayerImages.pause.rawValue : VideoPlayerImages.play.rawValue),
            for: .normal
        )
    }
}

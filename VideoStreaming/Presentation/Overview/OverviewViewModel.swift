//
//  OverviewViewModel.swift
//  VideoStreaming
//
//  Created by Niroshan Maheswaran on 28.11.21.
//

import Foundation

protocol OverviewViewModel {
    
    /// List of local and remote videos.
    var videos: [Video] { get }
}

class OverviewModelImpl: OverviewViewModel {
    
    // MARK: - Public properties
    
    var videos: [Video] = []
    
    // MARK: - Dependecies
    
    private let repository: VideoRepository = VideoRepositoryImpl()
    
    // MARK: - Public methods
    
    init() {
        videos = repository.fetchLocalVideos() + repository.fetchRemoteVideos()
    }
}

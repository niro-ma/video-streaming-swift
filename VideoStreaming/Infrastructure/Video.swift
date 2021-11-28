//
//  Video.swift
//  VideoStreaming
//
//  Created by Niroshan Maheswaran on 28.11.21.
//

import Foundation

struct Video: Decodable, Identifiable {
    
    // MARK: - Public properties
    
    /// Unique id of video.
    let id = UUID()
    
    /// Title of video.
    let title: String
    
    /// Filename of video.
    let fileName: String
    
    /// Subtitle of video.
    let subtitle: String
    
    /// Remote URL of video.
    let remoteVideoURL: URL?
    
    /// Local video URL.
    var localVideoURL: URL? {
        return Bundle.main.url(forResource: fileName, withExtension: "mp4")
    }
    
    /// Local or remote video URL.
    var videoURL: URL? {
        return remoteVideoURL ?? localVideoURL
    }
    
    // MARK: - Private properties
    
    private enum CodingKeys: String, CodingKey {
        case title, subtitle
        case fileName = "file_name"
        case remoteVideoURL = "remote_video_url"
    }
}

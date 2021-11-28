//
//  VideoRepository.swift
//  VideoStreaming
//
//  Created by Niroshan Maheswaran on 28.11.21.
//

import Foundation

/// Helps to decode json files.
private enum JSONDecoderHelper {
    
    /// Generic decoder.
    static func decode<T: Decodable>(fileName: String) -> [T] {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                return try JSONDecoder().decode([T].self, from: data)
            } catch {
                print("Failed decoding JSON file: \(fileName).")
                return []
            }
        }
        return []
    }
}

/// Filenames.
fileprivate enum FileNames: String {
    case localVideos = "LocalVideos"
    case remoteVideos = "RemoteVideos"
}

protocol VideoRepository {
    
    /// Returns list of local videos.
    func fetchLocalVideos() -> [Video]
    
    /// Returns list of remote videos.
    func fetchRemoteVideos() -> [Video]
}

class VideoRepositoryImpl: VideoRepository {
    
    // MARK: - Public methods
    
    func fetchLocalVideos() -> [Video] {
        return JSONDecoderHelper.decode(fileName: FileNames.localVideos.rawValue)
    }
    
    /// Returns list of remote videos.
    func fetchRemoteVideos() -> [Video] {
        return JSONDecoderHelper.decode(fileName: FileNames.remoteVideos.rawValue)
    }
}

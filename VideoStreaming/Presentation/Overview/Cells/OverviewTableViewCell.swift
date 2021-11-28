//
//  OverviewTableViewCell.swift
//  VideoStreaming
//
//  Created by Niroshan Maheswaran on 28.11.21.
//

import UIKit
import AVFoundation

enum OverviewImages: String {
    case play = "play.fill"
}

class OverviewTableViewCell: UITableViewCell {

    // MARK: - Outlets
    
    @IBOutlet private weak var contenView: UIView!
    @IBOutlet private weak var wrapperView: UIView!
    @IBOutlet private weak var videoImageView: UIImageView!
    @IBOutlet private weak var playImageView: UIImageView!
    @IBOutlet private weak var overlayView: UIView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    @IBOutlet private weak var videoTypeIdentifierView: UIView!
    @IBOutlet private weak var videoTyoeIdentifierLabel: UILabel!
    
    // MARK: - Public properties
    
    /// Cell height.
    static let cellHeight: CGFloat = 250
    
    /// Cell identifier.
    static var cellIdentifier: String {
        String(describing: Self.self)
    }
    
    // MARK: - Private properties
    
    private var createdThumbnailData: Data?
    
    // MARK: - Public methods
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func setupCell(withVideo video: Video) {
        titleLabel.text = video.title
        subtitleLabel.text = video.subtitle
        if let url = video.remoteVideoURL {
            videoImageView.image = createVideoThumbnail(from: url)
            videoTyoeIdentifierLabel.text = "Remote"
        } else {
            if let path = video.localVideoURL {
                videoImageView.image = generateThumbnail(path: path)
            }
            videoTyoeIdentifierLabel.text = "Local"
        }
    }
}

// MARK: - Private methods

private extension OverviewTableViewCell {
    
    func setupView() {
        backgroundColor = .clear
        contenView.backgroundColor = .clear
        
        wrapperView.layer.cornerRadius = 8
        wrapperView.clipsToBounds = true
        
        overlayView.backgroundColor = .black
        overlayView.alpha = 0.5
        
        titleLabel.textColor = .white
        subtitleLabel.textColor = .white
        
        playImageView.tintColor = .orange
        playImageView.image = UIImage(systemName: OverviewImages.play.rawValue)
        
        videoTypeIdentifierView.backgroundColor = UIColor(white: 1, alpha: 0.7)
        videoTypeIdentifierView.layer.cornerRadius = videoTypeIdentifierView.frame.height / 2
        videoTyoeIdentifierLabel.textColor = .black
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
    func generateThumbnail(path: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: path, options: nil)
            let imgGenerator = AVAssetImageGenerator(asset: asset)
            imgGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imgGenerator.copyCGImage(at: CMTimeMake(value: 0, timescale: 1), actualTime: nil)
            let thumbnail = UIImage(cgImage: cgImage)
            return thumbnail
        } catch let error {
            print("*** Error generating thumbnail: \(error.localizedDescription)")
            return nil
        }
    }
    
    func createVideoThumbnail(from url: URL) -> UIImage? {
        guard createdThumbnailData == nil else {
            return UIImage(data: createdThumbnailData!)
        }
        let asset = AVAsset(url: url)
        let assetImgGenerate = AVAssetImageGenerator(asset: asset)
        assetImgGenerate.appliesPreferredTrackTransform = true
        assetImgGenerate.maximumSize = CGSize(width: frame.width, height: frame.height)

        let time = CMTimeMakeWithSeconds(0.0, preferredTimescale: 600)
        do {
            let img = try assetImgGenerate.copyCGImage(at: time, actualTime: nil)
            let thumbnail = UIImage(cgImage: img)
            createdThumbnailData = thumbnail.pngData()
            return thumbnail
        }
        catch {
          print(error.localizedDescription)
          return nil
        }

    }
}

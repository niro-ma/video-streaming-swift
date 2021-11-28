//
//  VideoOverviewViewController.swift
//  VideoStreaming
//
//  Created by Niroshan Maheswaran on 28.11.21.
//

import UIKit

class VideoOverviewViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet private weak var overviewTableView: UITableView!
    
    // MARK: - Dependencies
    
    private let viewModel: OverviewViewModel = OverviewModelImpl()
    
    // MARK: - Public methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
}

// MARK: - Private methods

private extension VideoOverviewViewController {
    
    func setupView() {
        navigationController?.navigationBar.tintColor = .black
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = .black
        
        overviewTableView.backgroundColor = .clear
        overviewTableView.delegate = self
        overviewTableView.dataSource = self
        overviewTableView.register(
            UINib(nibName: OverviewTableViewCell.cellIdentifier, bundle: nil),
            forCellReuseIdentifier: OverviewTableViewCell.cellIdentifier
        )
    }
}

// MARK: - UITableViewDelegate

extension VideoOverviewViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let video = viewModel.videos[indexPath.row]
        
        guard let videoPlayerVC = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(
            withIdentifier: String(describing: VideoPlayerViewController.self)
        ) as? VideoPlayerViewController else { return }
        videoPlayerVC.video = video
        navigationController?.pushViewController(videoPlayerVC, animated: true)
    }
}

// MARK: - UITableViewDataSource

extension VideoOverviewViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        OverviewTableViewCell.cellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.videos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = getOverviewCell(forIndexpath: indexPath)
        cell.setupCell(withVideo: viewModel.videos[indexPath.row])
        return cell
    }
    
    private func getOverviewCell(forIndexpath indexPath: IndexPath) -> OverviewTableViewCell {
        guard let cell = overviewTableView.dequeueReusableCell(
            withIdentifier: OverviewTableViewCell.cellIdentifier,
            for: indexPath
        ) as? OverviewTableViewCell else {
            preconditionFailure("Could not deque cell of type OverviewTableViewCell.")
        }
        return cell
    }
}

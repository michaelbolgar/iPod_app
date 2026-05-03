//
//  iPods

//  Created by Sakina Rajabova
//

import UIKit
import Networking

class ShareTestViewController: UIViewController {
    
    // MARK: - Properties
    private let podcastId: Int
    private var podcast: PodcastFull?
    
    // MARK: - UI Elements
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let authorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let shareButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Share", for: .normal)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    // MARK: - Init
    init(podcastId: Int) {
        self.podcastId = podcastId
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadPodcast()
    }
    
    // MARK: - Setup
    private func setupUI() {
        view.backgroundColor = .black
        title = "Podcast Details"
        
        [titleLabel, authorLabel, shareButton, activityIndicator].forEach {
            view.addSubview($0)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            authorLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            authorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            shareButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shareButton.topAnchor.constraint(equalTo: authorLabel.bottomAnchor, constant: 40),
            shareButton.widthAnchor.constraint(equalToConstant: 200),
            shareButton.heightAnchor.constraint(equalToConstant: 50),
            
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        shareButton.addTarget(self, action: #selector(shareTapped), for: .touchUpInside)
    }
    
    // MARK: - Load Podcast
    private func loadPodcast() {
        activityIndicator.startAnimating()
        
        Task {
            do {
                let apiPodcast = try await PodcastService().getPodcastByID(podcastId)
                
                // Convert API model to PodcastFull
                                self.podcast = PodcastFull(
                                    id: apiPodcast.id,
                                    title: apiPodcast.title ?? "No title",
                                    author: apiPodcast.author ?? "Unknown author",
                                    genre: "",
                                    rating: 0,
                                    episodeCount: 0,
                                    description: "",
                                    progress: 0
                                )
                                
                                await MainActor.run {
                                    activityIndicator.stopAnimating()
                                    updateUI()
                                }
                            } catch {
                                await MainActor.run {
                                    activityIndicator.stopAnimating()
                                    titleLabel.text = "Podcast #\(podcastId) not found"
                                    authorLabel.text = error.localizedDescription
                                }
                                print("Error loading podcast: \(error)")
                            }
                        }
                    }
                    
                    private func updateUI() {
                        guard let podcast = podcast else { return }
                        titleLabel.text = podcast.title
                        authorLabel.text = podcast.author
                    }
                    
                    // MARK: - Share
                    @objc private func shareTapped() {
                        guard let podcast = podcast else { return }
                        
                        // Create deep link URL
                        let deepLinkURL = URL(string: "podcastapp://episode?id=\(podcast.id)")!
                        let textToShare = "Listen to \"\(podcast.title)\" by \(podcast.author)"
                        
                        let activityVC = UIActivityViewController(
                            activityItems: [textToShare, deepLinkURL],
                            applicationActivities: nil
                        )
                        
                        if let popover = activityVC.popoverPresentationController {
                            popover.sourceView = shareButton
                            popover.sourceRect = shareButton.bounds
                        }
                        
                        present(activityVC, animated: true)
                    }
                }

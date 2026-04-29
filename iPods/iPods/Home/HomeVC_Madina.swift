import UIKit
import Networking

final class HomeVC_Madina: UIViewController, UISearchBarDelegate {
    
    // MARK: - Sections
    enum Section: Int, CaseIterable {
        case continueListening
        case trending
    }
    
    // MARK: - Constants
    private enum Layout {
        static let continueCellHeight: CGFloat = 88
        static let headerHeight: CGFloat = 44
    }
    
    // MARK: - UI
    let tableView = UITableView(frame: .zero, style: .plain)
    private let miniPlayer = MiniPlayerView()
    private var miniPlayerBottom: NSLayoutConstraint!

    // MARK: - Services

    private let podcastService = try? PodcastService()
    private var episodeLoadTask: Task<Void, Never>?
    
    var filteredPodcasts: [PodcastFull] = []
    var searchHistory: [String] = []
    let searchBar = UISearchBar()
    
    // MARK: - Data
    let continueData: [PodcastFull] = [
        PodcastFull(title: "The Creative Mind", author: "Sarah Johnson",
                    genre: "Arts", rating: 4.7, episodeCount: 89,
                    description: "Exploring creativity in all its forms.", progress: 0.6),
        PodcastFull(title: "Deep Conversations", author: "Marcus Chen",
                    genre: "Society", rating: 4.5, episodeCount: 120,
                    description: "Meaningful dialogues with thought leaders.", progress: 0.3)
    ]

    var trendingData: [PodcastFull] = []
  
  
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavigationBar()
        setupSearchBar()
        setupTableView()
        setupMiniPlayer()
        setupSearchViews()
        addKeyboardDismissGesture()
        loadTrending()
    }

    private func loadTrending() {
        guard let service = podcastService else { return }
        Task { [weak self] in
            guard let self else { return }
            do {
                let podcasts = try await service.getTrending(max: 10)
                let mapped = podcasts.map { podcast in
                    PodcastFull(
                        title: podcast.title,
                        author: podcast.author ?? "",
                        genre: "",
                        rating: 0,
                        episodeCount: 0,
                        description: "",
                        progress: 0,
                        artworkURL: podcast.imageURL,
                        feedID: podcast.id
                    )
                }
                await MainActor.run {
                    self.trendingData = mapped
                    self.tableView.reloadData()
                }
            } catch {
                // network or decoding error — trending stays empty
            }
        }
    }

    private func loadEpisodesAndPlay(for podcast: PodcastFull) {
        guard let feedID = podcast.feedID, let service = podcastService else { return }
        episodeLoadTask?.cancel()
        episodeLoadTask = Task {
            do {
                let episodes = try await service.getEpisodes(feedID: feedID, max: 20)
                guard !episodes.isEmpty, !Task.isCancelled else { return }
                await MainActor.run {
                    PlayerService.shared.startPlayback(episodes: episodes, index: 0)
                }
            } catch {
                // network or decoding error — playback not started
            }
        }
    }
    
    // MARK: - Setup
    private func setupNavigationBar() {
        navigationItem.title = "Listen Now"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.isTranslucent = false
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInsetAdjustmentBehavior = .automatic
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContinueCell.self, forCellReuseIdentifier: ContinueCell.reuseID)
        tableView.register(TrendingCell.self, forCellReuseIdentifier: TrendingCell.reuseID)
        //tableView.tableHeaderView = makeSearchBar()
        
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    
    private func setupSearchBar() {
        searchBar.placeholder = "Search podcasts..."
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            searchBar.heightAnchor.constraint(equalToConstant: 52)
        ])
    }
    
    private func setupMiniPlayer() {
        miniPlayer.translatesAutoresizingMaskIntoConstraints = false
        miniPlayer.isHidden = true
        view.addSubview(miniPlayer)
        
        miniPlayerBottom = miniPlayer.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 80
        )
        
        NSLayoutConstraint.activate([
            miniPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            miniPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            miniPlayer.heightAnchor.constraint(equalToConstant: 64),
            miniPlayerBottom
        ])
        
        miniPlayer.onPlay = {
            print("play tapped")
        }
    }
    
    // MARK: - Mini Player
    private func showMiniPlayer(with podcast: PodcastFull) {
        miniPlayer.configure(with: podcast)
        miniPlayer.isHidden = false
        miniPlayerBottom.constant = -8
        
        UIView.animate(withDuration: 0.3,
                       delay: 0,
                       usingSpringWithDamping: 0.8,
                       initialSpringVelocity: 0,
                       options: .curveEaseOut) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - UITableViewDataSource & Delegate

extension HomeVC_Madina: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === resultsTableView || tableView === historyTableView {
            return numberOfRows(in: tableView)
        }
        guard let section = Section(rawValue: section) else { return 0 }
        switch section {
        case .continueListening: return continueData.count
        case .trending: return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === resultsTableView || tableView === historyTableView {
            return searchCell(for: tableView, at: indexPath)
        }
        guard let section = Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }
        switch section {
        case .continueListening:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ContinueCell.reuseID, for: indexPath) as! ContinueCell
            cell.configure(with: continueData[indexPath.row])
            return cell
        case .trending:
            let cell = tableView.dequeueReusableCell(
                withIdentifier: TrendingCell.reuseID, for: indexPath) as! TrendingCell
            cell.configure(with: trendingData)
            cell.onSelect = { [weak self] index in
                guard let self, index < self.trendingData.count else { return }
                let podcast = self.trendingData[index]
                self.showMiniPlayer(with: podcast)
                self.loadEpisodesAndPlay(for: podcast)
                let vc = DetailsViewController(podcast: podcast)
                self.navigationController?.pushViewController(vc, animated: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section) else { return 0 }
        switch section {
        case .continueListening:
            return Layout.continueCellHeight
        case .trending:
            let cardWidth = (UIScreen.main.bounds.width - 32 - 12) / 2
            let cardHeight = cardWidth + 50
            return (cardHeight * 2) + 12 + 24
        }
    }
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        guard let section = Section(rawValue: section) else { return nil }
        switch section {
        case .continueListening: return SectionHeaderView(title: "Continue Listening")
        case .trending: return SectionHeaderView(title: "🔥 Trending Now")
        }
    }
    
    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        Layout.headerHeight
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === resultsTableView || tableView === historyTableView {
            searchDidSelect(in: tableView, at: indexPath)
            return
        }
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = Section(rawValue: indexPath.section) else { return }
        switch section {
        case .continueListening:
            let podcast = continueData[indexPath.row]
            showMiniPlayer(with: podcast)
            let vc = DetailsViewController(podcast: podcast)
            navigationController?.pushViewController(vc, animated: true)
        case .trending:
            break
        }
    }
}


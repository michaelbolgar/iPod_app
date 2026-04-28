//
//  HomeVC.swift
//  iPods
//
//  Created by Administration  on 28/04/26.
//



// HomeVC.swift
// iPods

// HomeVC.swift
// iPods

// HomeVC.swift
// iPods

import UIKit

final class HomeVC_Madina: UIViewController {

    // MARK: - Sections

    enum Section: Int, CaseIterable {
        case continueListening
        case trending
    }

    // MARK: - Layout

    private enum Layout {
        static let continueHeight: CGFloat = 88
        static let headerHeight: CGFloat = 44
        static let searchHeight: CGFloat = 52
    }

    // MARK: - UI

    private let tableView = UITableView(frame: .zero, style: .plain)
    private let miniPlayer = MiniPlayerView()
    private var miniPlayerBottom: NSLayoutConstraint!

    private let loadingIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .medium)
        ai.color = .white
        ai.hidesWhenStopped = true
        ai.translatesAutoresizingMaskIntoConstraints = false
        return ai
    }()

    // MARK: - Data

    private var continueData: [PodcastFull] = []
    private var trendingData: [PodcastFull] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupNavigationBar()
        setupTableView()
        setupMiniPlayer()
        setupLoadingIndicator()
        mockContinue()
        loadTrending()
    }

    // MARK: - Setup

    private func setupNavigationBar() {
        navigationItem.title = "Listen Now"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }

    private func setupTableView() {
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(ContinueCell.self, forCellReuseIdentifier: ContinueCell.reuseID)
        tableView.register(TrendingCell.self, forCellReuseIdentifier: TrendingCell.reuseID)
        tableView.tableHeaderView = makeSearchBar()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func makeSearchBar() -> UISearchBar {
        let searchBar = UISearchBar(frame: CGRect(
            x: 0, y: 0,
            width: view.frame.width,
            height: Layout.searchHeight
        ))
        searchBar.placeholder = "Search podcasts..."
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .white
        return searchBar
    }

    private func setupMiniPlayer() {
        miniPlayer.translatesAutoresizingMaskIntoConstraints = false
        miniPlayer.isHidden = true
        view.addSubview(miniPlayer)

        miniPlayerBottom = miniPlayer.bottomAnchor.constraint(
            equalTo: view.safeAreaLayoutGuide.bottomAnchor,
            constant: 80
        )
        NSLayoutConstraint.activate([
            miniPlayer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 12),
            miniPlayer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -12),
            miniPlayer.heightAnchor.constraint(equalToConstant: 64),
            miniPlayerBottom
        ])
    }

    private func setupLoadingIndicator() {
        view.addSubview(loadingIndicator)
        NSLayoutConstraint.activate([
            loadingIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }

    // MARK: - Networking
    private func loadTrending() {
            loadingIndicator.startAnimating()
            print("🚀 loadTrending вызван")

            Task {
                let results = await ITunesService.fetchTrending()
                print("✅ получено подкастов:", results.count)

                await MainActor.run {
                    self.loadingIndicator.stopAnimating()
                    self.trendingData = results
                    print("📊 trendingData.count:", self.trendingData.count)
                    self.tableView.reloadData()
                }
            }
        }

        // MARK: - Mock continue

        private func mockContinue() {
            continueData = [
                PodcastFull(
                    title: "Design Talks",
                    author: "Anna",
                    genre: "Design",
                    rating: 4.5,
                    episodeCount: 20,
                    description: "",
                    artworkURL: nil,
                    progress: 0.4
                )
            ]
        }

        // MARK: - Mini Player

        private func showMiniPlayer(_ podcast: PodcastFull) {
            miniPlayer.configure(with: podcast)
            miniPlayer.isHidden = false
            miniPlayerBottom.constant = -8
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }

    // MARK: - UITableViewDataSource & UITableViewDelegate

    extension HomeVC_Madina: UITableViewDataSource, UITableViewDelegate {

        func numberOfSections(in tableView: UITableView) -> Int {
            Section.allCases.count
        }

        func tableView(_ tableView: UITableView,
                       numberOfRowsInSection section: Int) -> Int {
            guard let section = Section(rawValue: section) else { return 0 }
            switch section {
            case .continueListening: return continueData.count
            case .trending:          return trendingData.isEmpty ? 0 : 1
            }
        }

        func tableView(_ tableView: UITableView,
                       cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            guard let section = Section(rawValue: indexPath.section) else {
                return UITableViewCell()
            }
            switch section {
            case .continueListening:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: ContinueCell.reuseID, for: indexPath
                ) as! ContinueCell
                cell.configure(with: continueData[indexPath.row])
                return cell

            case .trending:
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: TrendingCell.reuseID, for: indexPath
                ) as! TrendingCell
                cell.configure(with: trendingData)
                cell.onSelect = { [weak self] index in
                    guard let self,
                          self.trendingData.indices.contains(index) else { return }
                    let podcast = self.trendingData[index]
                    self.showMiniPlayer(podcast)
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
                return Layout.continueHeight
            case .trending:
                let count = trendingData.count
                guard count > 0 else { return 0 }
                let rows = Int(ceil(Double(count) / 2.0))
                let width = UIScreen.main.bounds.width - 32
                let cardWidth = (width - 12) / 2
                let cardHeight = cardWidth + 50
                return CGFloat(rows) * cardHeight + CGFloat(rows - 1) * 12 + 24
            }
        }
        func tableView(_ tableView: UITableView,
                           viewForHeaderInSection section: Int) -> UIView? {
                guard let section = Section(rawValue: section) else { return nil }
                switch section {
                case .continueListening:
                    return continueData.isEmpty ? nil : SectionHeaderView(title: "Continue Listening")
                case .trending:
                    return trendingData.isEmpty ? nil : SectionHeaderView(title: "🔥 Trending Now")
                }
            }

            func tableView(_ tableView: UITableView,
                           heightForHeaderInSection section: Int) -> CGFloat {
                guard let section = Section(rawValue: section) else { return 0 }
                switch section {
                case .continueListening: return continueData.isEmpty ? 0 : Layout.headerHeight
                case .trending:          return trendingData.isEmpty ? 0 : Layout.headerHeight
                }
            }

            func tableView(_ tableView: UITableView,
                           didSelectRowAt indexPath: IndexPath) {
                tableView.deselectRow(at: indexPath, animated: true)
                guard let section = Section(rawValue: indexPath.section) else { return }
                if section == .continueListening,
                   continueData.indices.contains(indexPath.row) {
                    let podcast = continueData[indexPath.row]
                    showMiniPlayer(podcast)
                    let vc = DetailsViewController(podcast: podcast)
                    navigationController?.pushViewController(vc, animated: true)
                }
            }
        }

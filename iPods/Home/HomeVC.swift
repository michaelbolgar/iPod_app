//
//  HomeVC.swift
//  iPods
//
//  Created by Administration  on 28/04/26.
//
import UIKit

final class HomeVC_Madina: UIViewController {

    enum Section: Int, CaseIterable {
        case continueListening
        case trending
    }

    // MARK: - UI

    private let tableView = UITableView(frame: .zero, style: .plain)

    // MARK: - Data

    private var continueData: [PodcastFull] = []
    private var trendingData: [PodcastFull] = []

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setupUI()
        setupMockData()
    }

    // MARK: - Setup

    private func setupUI() {
        title = "Listen Now"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
        navigationController?.navigationBar.barStyle = .black

        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.showsVerticalScrollIndicator = false

        tableView.register(
            ContinueCell.self,
            forCellReuseIdentifier: ContinueCell.reuseID
        )

        tableView.register(
            TrendingCell.self,
            forCellReuseIdentifier: TrendingCell.reuseID
        )

        let searchBar = UISearchBar(
            frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 56)
        )
        searchBar.placeholder = "Search podcasts..."
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = UIColor(
            white: 0.12,
            alpha: 1
        )

        tableView.tableHeaderView = searchBar

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor
            ),
            tableView.bottomAnchor.constraint(
                equalTo: view.bottomAnchor
            ),
            tableView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor
            ),
            tableView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor
            )
        ])
    }

    // MARK: - Mock Data

    private func setupMockData() {
        continueData = [
            PodcastFull(
                title: "Creative Talks",
                author: "Jason Adams",
                genre: "Design",
                rating: 4.8,
                episodeCount: 20,
                description: "Creative podcast about design.",
                artworkURL: nil,
                progress: 0.6
            ),
            PodcastFull(
                title: "Morning Routine",
                author: "Lisa Parker",
                genre: "Lifestyle",
                rating: 4.7,
                episodeCount: 14,
                description: "Daily habits and productivity.",
                artworkURL: nil,
                progress: 0.35
            )
        ]
        trendingData = [
                    PodcastFull(
                        title: "Science Hour",
                        author: "Dr. James Park",
                        genre: "Science",
                        rating: 4.9,
                        episodeCount: 40,
                        description: "Science interviews.",
                        artworkURL: nil,
                        progress: 0
                    ),
                    PodcastFull(
                        title: "Deep Conversations",
                        author: "Maria Chen",
                        genre: "Lifestyle",
                        rating: 4.7,
                        episodeCount: 18,
                        description: "Meaningful interviews.",
                        artworkURL: nil,
                        progress: 0
                    ),
                    PodcastFull(
                        title: "Future Thinking",
                        author: "Alex Morgan",
                        genre: "Technology",
                        rating: 4.8,
                        episodeCount: 25,
                        description: "Tech and innovation.",
                        artworkURL: nil,
                        progress: 0
                    ),
                    PodcastFull(
                        title: "Mindset Lab",
                        author: "Emma Stone",
                        genre: "Self Growth",
                        rating: 4.6,
                        episodeCount: 30,
                        description: "Mindset and growth.",
                        artworkURL: nil,
                        progress: 0
                    ),
                    PodcastFull(
                        title: "Design Stories",
                        author: "Olivia Hart",
                        genre: "Design",
                        rating: 4.9,
                        episodeCount: 22,
                        description: "Product design stories.",
                        artworkURL: nil,
                        progress: 0
                    ),
                    PodcastFull(
                        title: "Business Weekly",
                        author: "Daniel Ross",
                        genre: "Business",
                        rating: 4.5,
                        episodeCount: 50,
                        description: "Startup and business.",
                        artworkURL: nil,
                        progress: 0
                    )
                ]

                tableView.reloadData()
            }

            // MARK: - Navigation

            private func openDetails(_ podcast: PodcastFull) {
                let vc = DetailsViewController(podcast: podcast)
                navigationController?.pushViewController(vc, animated: true)
            }
        }

        // MARK: - TableView

        extension HomeVC_Madina: UITableViewDataSource, UITableViewDelegate {

            func numberOfSections(in tableView: UITableView) -> Int {
                Section.allCases.count
            }

            func tableView(
                _ tableView: UITableView,
                numberOfRowsInSection section: Int
            ) -> Int {
                guard let section = Section(rawValue: section) else { return 0 }

                switch section {
                case .continueListening:
                    return continueData.count
                case .trending:
                    return 1
                }
            }

            func tableView(
                _ tableView: UITableView,
                cellForRowAt indexPath: IndexPath
            ) -> UITableViewCell {

                guard let section = Section(rawValue: indexPath.section) else {
                    return UITableViewCell()
                }

                switch section {

                case .continueListening:
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: ContinueCell.reuseID,
                        for: indexPath
                    ) as! ContinueCell

                    cell.configure(with: continueData[indexPath.row])
                    return cell

                case .trending:
                    let cell = tableView.dequeueReusableCell(
                        withIdentifier: TrendingCell.reuseID,
                        for: indexPath
                    ) as! TrendingCell

                    cell.configure(with: trendingData)

                    cell.onSelect = { [weak self] index in
                        guard let self else { return }
                        guard self.trendingData.indices.contains(index) else { return }
                        self.openDetails(self.trendingData[index])
                    }

                    return cell
                }
            }

            func tableView(
                _ tableView: UITableView,
                heightForRowAt indexPath: IndexPath
            ) -> CGFloat {
                indexPath.section == 0 ? 90 : 420
            }
            func tableView(
                    _ tableView: UITableView,
                    viewForHeaderInSection section: Int
                ) -> UIView? {

                    let container = UIView()
                    container.backgroundColor = .black

                    let label = UILabel()
                    label.textColor = .white
                    label.font = .boldSystemFont(ofSize: 20)

                    label.text = section == 0
                        ? "Continue Listening"
                        : "🔥 Trending Now"

                    container.addSubview(label)
                    label.translatesAutoresizingMaskIntoConstraints = false

                    NSLayoutConstraint.activate([
                        label.leadingAnchor.constraint(
                            equalTo: container.leadingAnchor,
                            constant: 16
                        ),
                        label.bottomAnchor.constraint(
                            equalTo: container.bottomAnchor,
                            constant: -6
                        )
                    ])

                    return container
                }

                func tableView(
                    _ tableView: UITableView,
                    heightForHeaderInSection section: Int
                ) -> CGFloat {
                    44
                }
            }

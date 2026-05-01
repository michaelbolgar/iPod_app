// HomeVC_Madina.swift
// iPods

import UIKit

final class HomeVC: UIViewController {

    enum Section: Int, CaseIterable {
        case continueListening
        case trending
    }

    private let tableView = UITableView(frame: .zero, style: .plain)

    private var continueData: [PodcastFull] = []
    private var trendingData: [PodcastFull] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black
        setupUI()
        setupMockData()
    }

    private func setupUI() {
        title = "Listen Now"

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: UIColor.white
        ]

        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self

        tableView.register(ContinueCell.self, forCellReuseIdentifier: ContinueCell.reuseID)
        tableView.register(TrendingCell.self, forCellReuseIdentifier: TrendingCell.reuseID)

        tableView.tableHeaderView = makeSearchBar()

        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }

    private func makeSearchBar() -> UIView {
        let searchBar = UISearchBar(
            frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 52)
        )
        searchBar.placeholder = "Search podcasts..."
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .white
        return searchBar
    }

    private func setupMockData() {
        continueData = [
            PodcastFull(
                title: "Creative Talks",
                author: "Jason Adams",
                genre: "Design",
                rating: 4.8,
                episodeCount: 20,
                description: "Creative podcast about design and ideas.",
                artworkURL: nil,
                progress: 0.6
            )
        ]

        trendingData = [
            PodcastFull(
                title: "Science Hour",
                author: "Dr. James Park",
                genre: "Science",
                rating: 4.9,
                episodeCount: 40,
                description: "Science stories and interviews.",
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
            )
        ]

        tableView.reloadData()
    }

    private func openDetails(_ podcast: PodcastFull) {
        let vc = DetailsViewController(podcast: podcast)
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        section == 0 ? continueData.count : 1
    }

    func tableView(
        _ tableView: UITableView,
        cellForRowAt indexPath: IndexPath
    ) -> UITableViewCell {

        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ContinueCell.reuseID,
                for: indexPath
            ) as! ContinueCell
            cell.configure(with: continueData[indexPath.row])
                        return cell
                    } else {
                        let cell = tableView.dequeueReusableCell(
                            withIdentifier: TrendingCell.reuseID,
                            for: indexPath
                        ) as! TrendingCell

                        cell.configure(with: trendingData)

                        cell.onSelect = { [weak self] index in
                            guard let self else { return }
                            self.openDetails(self.trendingData[index])
                        }

                        return cell
                    }
                }

                func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
                    indexPath.section == 0 ? 95 : 320
                }

                func tableView(_ tableView: UITableView,
                               viewForHeaderInSection section: Int) -> UIView? {
                    SectionHeaderView(
                        title: section == 0 ? "Continue Listening" : "🔥 Trending Now"
                    )
                }

                func tableView(_ tableView: UITableView,
                               heightForHeaderInSection section: Int) -> CGFloat {
                    44
                }
            }

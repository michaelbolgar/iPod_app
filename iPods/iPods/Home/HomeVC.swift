


//final class HomeVC {}






import UIKit

final class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

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

    // MARK: - Data

    private var continueData: [Podcast] = []
    private var trendingData: [Podcast] = []

    // MARK: - Service

    private let service: PodcastService = PodcastServiceImpl()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .black

        setupNavigationBar()
        setupTableView()
        setupMiniPlayer()

        loadData()
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

        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white
        ]
    }

    private func setupTableView() {
        tableView.backgroundColor = .black
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false

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

    private func makeSearchBar() -> UISearchBar {
        let searchBar = UISearchBar(frame: CGRect(
            x: 0,
            y: 0,
            width: view.frame.width,
            height: Layout.searchHeight
        ))

        searchBar.placeholder = "Search podcasts..."
        searchBar.searchBarStyle = .minimal
        searchBar.searchTextField.textColor = .white
        searchBar.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.08)

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

        miniPlayer.onPlay = {
            print("play tapped")
        }
    }

    // MARK: - Data

    private func loadData() {
        Task {
            await loadTrending()
        }
    }

    private func loadTrending() async {
        do {
            trendingData = try await service.fetchTrending()

            await MainActor.run {
                tableView.reloadData()
                            }
                        } catch {
                            print("❌ trending error:", error)
                        }
                    }

                    // MARK: - Mini Player

                    private func showMiniPlayer(with podcast: Podcast) {
                        miniPlayer.configure(with: podcast)
                        miniPlayer.isHidden = false

                        miniPlayerBottom.constant = -8

                        UIView.animate(withDuration: 0.3) {
                            self.view.layoutIfNeeded()
                        }
                    }

                    // MARK: - UITableViewDataSource

                    func numberOfSections(in tableView: UITableView) -> Int {
                        Section.allCases.count
                    }

                    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

                        guard let section = Section(rawValue: section) else { return 0 }

                        switch section {
                        case .continueListening:
                            return continueData.count
                        case .trending:
                            return trendingData.isEmpty ? 0 : 1
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

                            cell.onSelect = { [weak self] podcast in
                                guard let self else { return }

                                self.showMiniPlayer(with: podcast)

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
                            let width = UIScreen.main.bounds.width - 32
                            let cardWidth = (width - 12) / 2
                            let cardHeight = cardWidth + 50

                            return (cardHeight * 2) + 12 + 24
                        }
                    }

                    func tableView(_ tableView: UITableView,
                                   viewForHeaderInSection section: Int) -> UIView? {

                        guard let section = Section(rawValue: section) else { return nil }

                        switch section {
                        case .continueListening:
                            return continueData.isEmpty ? nil : SectionHeaderView(title: "Continue Listening")
                        case .trending:
                            return SectionHeaderView(title: "🔥 Trending Now")
                        }
                    }

                    func tableView(_ tableView: UITableView,
                                   heightForHeaderInSection section: Int) -> CGFloat {
                        Layout.headerHeight
                    }

                    func tableView(_ tableView: UITableView,
                                   didSelectRowAt indexPath: IndexPath) {

                        tableView.deselectRow(at: indexPath, animated: true)

                        guard let section = Section(rawValue: indexPath.section) else { return }

                        switch section {
                        case .continueListening:
                            let model = continueData[indexPath.row]

                            showMiniPlayer(with: model)

                            let vc = DetailsViewController(podcast: model)
                            navigationController?.pushViewController(vc, animated: true)

                        case .trending:
                            break
                        }
                    }
                }

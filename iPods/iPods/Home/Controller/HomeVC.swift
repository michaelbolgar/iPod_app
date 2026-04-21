import UIKit
import SnapKit

final class HomeVC: UIViewController {

    private var homeView: HomeView { view as! HomeView }

    private let allPodcasts: [Podcast] = [
        Podcast(title: "The Creative Mind", author: "Sarah Johnson"),
        Podcast(title: "Deep Conversations", author: "Marcus Chen"),
        Podcast(title: "Floyymenor Gata Only", author: "Ft.Criss Mj"),
        Podcast(title: "Jet", author: "Macan")
    ]

    private var filteredPodcasts: [Podcast] = []
    private var searchHistory: [String] = []

    // MARK: - Lifecycle
    override func loadView() {
        view = HomeView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        homeView.searchBar.delegate = self
        homeView.resultsTableView.dataSource = self
        homeView.resultsTableView.delegate = self
        homeView.historyTableView.dataSource = self
        homeView.historyTableView.delegate = self
        addKeyboardDismissGesture()
    }

    // MARK: - View States
    private func showHomeState() {
        homeView.homeContentView.isHidden = false
        homeView.resultsTableView.isHidden = true
        homeView.historyTableView.isHidden = true
        homeView.emptyStateView.isHidden = true
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.homeView.homeContentView.alpha = 1
        }
    }

    private func showHistoryState() {
        homeView.homeContentView.isHidden = true
        homeView.resultsTableView.isHidden = true
        homeView.emptyStateView.isHidden = true
        homeView.historyTableView.isHidden = false
        homeView.historyTableView.reloadData()
    }

    private func showResultsState() {
        homeView.homeContentView.isHidden = true
        homeView.historyTableView.isHidden = true
        homeView.emptyStateView.isHidden = true
        homeView.resultsTableView.isHidden = false
        homeView.resultsTableView.reloadData()
    }

    private func showEmptyState() {
        homeView.homeContentView.isHidden = true
        homeView.historyTableView.isHidden = true
        homeView.resultsTableView.isHidden = true
        homeView.emptyStateView.isHidden = false
    }

    // MARK: - Search Logic
    private func activateSearch() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.homeView.homeContentView.alpha = 0
        } completion: { [weak self] _ in
            guard let self else { return }
            if !self.searchHistory.isEmpty {
                self.showHistoryState()
            } else {
                self.homeView.homeContentView.isHidden = true
            }
        }
    }

    private func deactivateSearch() {
        homeView.searchBar.text = ""
        homeView.searchBar.resignFirstResponder()
        filteredPodcasts = []
        showHomeState()
    }

    private func performSearch(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)

        if trimmed.isEmpty {
            if !searchHistory.isEmpty {
                showHistoryState()
            }
            return
        }

        filteredPodcasts = allPodcasts.filter {
            $0.title.lowercased().contains(trimmed.lowercased()) ||
            $0.author.lowercased().contains(trimmed.lowercased())
        }

        if filteredPodcasts.isEmpty {
            showEmptyState()
        } else {
            showResultsState()
        }
    }

    private func saveToHistory(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !searchHistory.contains(trimmed) else { return }
        searchHistory.insert(trimmed, at: 0)
        if searchHistory.count > 10 { searchHistory.removeLast() }
    }
}

// MARK: - UISearchBarDelegate
extension HomeVC: UISearchBarDelegate {

    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)
        activateSearch()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        performSearch(query: searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        saveToHistory(query)
        searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        if let query = homeView.searchBar.text,
           !query.trimmingCharacters(in: .whitespaces).isEmpty {
            saveToHistory(query)
        }
        searchBar.setShowsCancelButton(false, animated: true)
        deactivateSearch()
    }
}

// MARK: - UITableViewDataSource
extension HomeVC: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView === homeView.resultsTableView {
            return filteredPodcasts.count
        } else {
            return searchHistory.count + 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView === homeView.resultsTableView {
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultCell.reuseID,
                for: indexPath
            ) as! SearchResultCell
            cell.configure(title: filteredPodcasts[indexPath.row].title,
                           author: filteredPodcasts[indexPath.row].author)
            return cell
            
        } else {
            if indexPath.row == 0 {
                return tableView.dequeueReusableCell(
                    withIdentifier: SearchHistoryHeaderCell.reuseID,
                    for: indexPath
                ) as! SearchHistoryHeaderCell
            } else {
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchHistoryCell.reuseID,
                    for: indexPath
                ) as! SearchHistoryCell
                cell.configure(query: searchHistory[indexPath.row - 1])
                return cell
            }
        }
    }
}

// MARK: - UITableViewDelegate
extension HomeVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView === homeView.historyTableView && indexPath.row == 0 {
            return 50
        }
        return 72
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView === homeView.resultsTableView {
            let detailsVC = DetailsVC()
            navigationController?.pushViewController(detailsVC, animated: true)
        } else if tableView === homeView.historyTableView && indexPath.row > 0 {
            let query = searchHistory[indexPath.row - 1]
            homeView.searchBar.text = query
            performSearch(query: query)
        }
    }
}

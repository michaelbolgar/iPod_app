//
//  HomeViewController+Search.swift
//  iPods
//
//  Created by Hoshimov Matin on 24/04/26.
//

import UIKit
import SnapKit
import Networking

extension HomeVC_Madina {
    
    func setupSearchViews() {
        [searchResultsTableView, emptySearchView].forEach {
            view.addSubview($0)
        }
        
        searchResultsTableView.dataSource = self
        searchResultsTableView.delegate = self
                
        searchResultsTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        emptySearchView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }

    // MARK: - States
    func showHomeState() {
        currentSearchState = .home
        searchResultsTableView.isHidden = true
        emptySearchView.isHidden = true
        tableView.isHidden = false
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.tableView.alpha = 1
        }
    }

    func showHistoryState() {
        currentSearchState = .history
        tableView.isHidden = true
        emptySearchView.isHidden = true
        searchResultsTableView.isHidden = false
        searchResultsTableView.reloadData()
    }

    func showResultsState() {
        currentSearchState = .results
        tableView.isHidden = true
        emptySearchView.isHidden = true
        searchResultsTableView.isHidden = false
        searchResultsTableView.reloadData()
    }

    func showEmptyState() {
        currentSearchState = .empty
        tableView.isHidden = true
        searchResultsTableView.isHidden = true
        emptySearchView.isHidden = false
    }

    // MARK: - Search Logic
    func activateSearch() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.tableView.alpha = 0
        } completion: { [weak self] _ in
            guard let self else { return }
            self.tableView.isHidden = true
            let currentText = self.searchBar.text?.trimmingCharacters(in: .whitespaces) ?? ""
            if currentText.isEmpty && !self.searchHistory.isEmpty {
                self.showHistoryState()
            }
        }
    }

    func deactivateSearch() {
        searchTask?.cancel()
        filteredPodcasts = []
        showHomeState()
    }

    func performSearch(query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        searchTask?.cancel()

        if trimmed.isEmpty {
            filteredPodcasts = []
            if !searchHistory.isEmpty {
                showHistoryState()
            } else {
                tableView.isHidden = true
                searchResultsTableView.isHidden = true
                emptySearchView.isHidden = true
            }
            return
        }

        guard let service = podcastService else { return }

        searchTask = Task { [weak self] in
            guard let self else { return }
            do {
                try await Task.sleep(nanoseconds: 300_000_000)
                let podcasts = try await service.doSearch(query: trimmed)
                guard !Task.isCancelled else { return }
                let mapped = podcasts.map { podcast in
                    PodcastFull(
                        id: 0,
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
                    self.filteredPodcasts = mapped
                    mapped.isEmpty ? self.showEmptyState() : self.showResultsState()
                }
            } catch { }
        }
    }

    func saveToHistory(_ query: String) {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty, !searchHistory.contains(trimmed) else { return }
        searchHistory.insert(trimmed, at: 0)
        if searchHistory.count > 10 { searchHistory.removeLast() }
    }

    // MARK: - UISearchBarDelegate
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
        if let query = searchBar.text,
           !query.trimmingCharacters(in: .whitespaces).isEmpty {
            saveToHistory(query)
        }
        searchBar.text = ""
        searchBar.resignFirstResponder()
        searchBar.setShowsCancelButton(false, animated: true)
        deactivateSearch()
    }

    // MARK: - TableView helpers для searchResultsTableView
    func numberOfSearchRows(in section: Int) -> Int {
        switch currentSearchState {
        case .results:
            return filteredPodcasts.count
        case .history:
            return searchHistory.count + 1
        default:
            return 0
        }
    }

    func searchCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        switch currentSearchState {
        case .results:
            guard indexPath.row < filteredPodcasts.count else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultCell.reuseID,
                for: indexPath
            ) as! SearchResultCell
            let podcast = filteredPodcasts[indexPath.row]
            cell.configure(title: podcast.title, author: podcast.author, artworkURL: podcast.artworkURL)
            return cell

        case .history:
            if indexPath.row == 0 {
                return tableView.dequeueReusableCell(
                    withIdentifier: SearchHistoryHeaderCell.reuseID,
                    for: indexPath
                ) as! SearchHistoryHeaderCell
            } else {
                guard indexPath.row - 1 < searchHistory.count else { return UITableViewCell() }
                let cell = tableView.dequeueReusableCell(
                    withIdentifier: SearchHistoryCell.reuseID,
                    for: indexPath
                ) as! SearchHistoryCell
                cell.configure(query: searchHistory[indexPath.row - 1])
                return cell
            }

        default:
            return UITableViewCell()
        }
    }

    func searchDidSelect(at indexPath: IndexPath) {
        switch currentSearchState {
        case .results:
            guard indexPath.row < filteredPodcasts.count else { return }
            let podcast = filteredPodcasts[indexPath.row]
            showMiniPlayer(with: podcast)
            loadEpisodesAndPlay(for: podcast)
            let vc = DetailsViewController(podcast: podcast)
            navigationController?.pushViewController(vc, animated: true)

        case .history:
            guard indexPath.row > 0, indexPath.row - 1 < searchHistory.count else { return }
            let query = searchHistory[indexPath.row - 1]
            searchBar.text = query
            searchBar.setShowsCancelButton(true, animated: true)
            performSearch(query: query)

        default:
            break
        }
    }
}

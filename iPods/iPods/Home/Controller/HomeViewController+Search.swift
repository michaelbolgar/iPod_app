//
//  HomeViewController+Search.swift
//  iPods
//
//  Created by Hoshimov Matin on 24/04/26.
//

import UIKit
import SnapKit
import Networking

// MARK: - Search UI Setup
extension HomeVC_Madina {
    
    func setupSearchViews() {
        [resultsTableView, historyTableView, emptyStateView].forEach {
            view.addSubview($0)
        }
        
        resultsTableView.dataSource = self
        resultsTableView.delegate = self
        historyTableView.dataSource = self
        historyTableView.delegate = self
        
        resultsTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }

        historyTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
        
        emptyStateView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.keyboardLayoutGuide.snp.top)
        }
    }
    
    // MARK: - Search Views
    var resultsTableView: UITableView {
        if let tv = view.viewWithTag(101) as? UITableView { return tv }
        let tv = UITableView()
        tv.tag = 101
        tv.backgroundColor = .black
        tv.separatorStyle = .none
        tv.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
        tv.isHidden = true
        tv.keyboardDismissMode = .onDrag
        return tv
    }
    
    var historyTableView: UITableView {
        if let tv = view.viewWithTag(102) as? UITableView { return tv }
        let tv = UITableView()
        tv.tag = 102
        tv.backgroundColor = .black
        tv.separatorStyle = .none
        tv.register(SearchHistoryCell.self, forCellReuseIdentifier: SearchHistoryCell.reuseID)
        tv.register(SearchHistoryHeaderCell.self, forCellReuseIdentifier: SearchHistoryHeaderCell.reuseID)
        tv.isHidden = true
        tv.keyboardDismissMode = .onDrag
        return tv
    }
    
    var emptyStateView: UIView {
        if let v = view.viewWithTag(103) { return v }
        let v = UIView()
        v.tag = 103
        v.backgroundColor = .black
        v.isHidden = true
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 12
        stack.alignment = .center
        
        let emoji = UILabel()
        emoji.text = "🎙️"
        emoji.font = .systemFont(ofSize: 60)
        
        let title = UILabel()
        title.text = "Ничего не найдено"
        title.textColor = .white
        title.font = .systemFont(ofSize: 18, weight: .bold)
        
        let subtitle = UILabel()
        subtitle.text = "Попробуйте другой запрос"
        subtitle.textColor = .systemGray
        subtitle.font = .systemFont(ofSize: 14)
        
        [emoji, title, subtitle].forEach { stack.addArrangedSubview($0) }
        v.addSubview(stack)
        
        stack.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.leading.trailing.equalToSuperview().inset(32)
        }
        
        return v
    }
    
    // MARK: - States
    func showHomeState() {
        resultsTableView.isHidden = true
        historyTableView.isHidden = true
        emptyStateView.isHidden = true
        tableView.isHidden = false
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.tableView.alpha = 1
        }
    }
    
    func showHistoryState() {
        tableView.isHidden = true
        resultsTableView.isHidden = true
        emptyStateView.isHidden = true
        historyTableView.isHidden = false
        historyTableView.reloadData()
    }
    
    func showResultsState() {
        tableView.isHidden = true
        historyTableView.isHidden = true
        emptyStateView.isHidden = true
        resultsTableView.isHidden = false
        resultsTableView.reloadData()
    }
    
    func showEmptyState() {
        tableView.isHidden = true
        historyTableView.isHidden = true
        resultsTableView.isHidden = true
        emptyStateView.isHidden = false
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
                resultsTableView.isHidden = true
                emptyStateView.isHidden = true
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
            } catch {
                // network or decoding error — results stay empty
            }
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
    
    // MARK: - TableView helpers
    func numberOfRows(in tableView: UITableView) -> Int {
        if tableView === resultsTableView {
            return filteredPodcasts.count
        } else {
            return searchHistory.count + 1
        }
    }
    
    func searchCell(for tableView: UITableView, at indexPath: IndexPath) -> UITableViewCell {
        if tableView === resultsTableView {
            guard indexPath.row < filteredPodcasts.count else { return UITableViewCell() }
            let cell = tableView.dequeueReusableCell(
                withIdentifier: SearchResultCell.reuseID,
                for: indexPath
            ) as! SearchResultCell
            let podcast = filteredPodcasts[indexPath.row]
            cell.configure(title: podcast.title, author: podcast.author, artworkURL: podcast.artworkURL)
            return cell
        } else {
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
        }
    }
    
    func searchDidSelect(in tableView: UITableView, at indexPath: IndexPath) {
        if tableView === resultsTableView {
            guard indexPath.row < filteredPodcasts.count else { return }
            let podcast = filteredPodcasts[indexPath.row]
            showMiniPlayer(with: podcast)
            loadEpisodesAndPlay(for: podcast)
            let vc = DetailsViewController(podcast: podcast)
            navigationController?.pushViewController(vc, animated: true)
        } else if tableView === historyTableView && indexPath.row > 0 {
            let query = searchHistory[indexPath.row - 1]
            searchBar.text = query
            searchBar.setShowsCancelButton(true, animated: true)
            performSearch(query: query)
        }
    }
}

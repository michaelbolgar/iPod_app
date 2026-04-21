//
//  HomeView.swift
//  iPods
//
//  Created by Hoshimov Matin on 17/04/26.
//

import UIKit
import SnapKit
import DesignSys

final class HomeView: UIView {

    // MARK: - UI Elements
    let titleLabel = DesignFactory.makePrimaryLabel(text: "Listen Now", size: 28)

    let searchBar: UISearchBar = {
        let sb = UISearchBar()
        sb.placeholder = "Search podcasts..."
        sb.barTintColor = AppColor.background
        sb.searchTextField.backgroundColor = UIColor.white.withAlphaComponent(0.08)
        sb.searchTextField.textColor = AppColor.white
        sb.searchTextField.attributedPlaceholder = NSAttributedString(
            string: "Search podcasts...",
            attributes: [.foregroundColor: AppColor.secondary]
        )
        sb.searchTextField.leftView?.tintColor = AppColor.secondary
        sb.tintColor = AppColor.primary
        sb.backgroundImage = UIImage()
        sb.searchTextField.clearButtonMode = .never
        return sb
    }()

    let homeContentView: UIView = {
        let v = UIView()
        v.backgroundColor = .clear
        return v
    }()

    let resultsTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.register(SearchResultCell.self, forCellReuseIdentifier: SearchResultCell.reuseID)
        tv.isHidden = true
        tv.keyboardDismissMode = .onDrag
        return tv
    }()

    let historyTableView: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = .clear
        tv.separatorStyle = .none
        tv.register(SearchHistoryCell.self, forCellReuseIdentifier: SearchHistoryCell.reuseID)
        tv.register(SearchHistoryHeaderCell.self, forCellReuseIdentifier: SearchHistoryHeaderCell.reuseID)
        tv.isHidden = true
        tv.keyboardDismissMode = .onDrag
        return tv
    }()
    
    let emptyStateView: UIView = {
        let v = UIView()
        v.isHidden = true

        let emoji = UILabel()
        emoji.text = "🎙️"
        emoji.font = .systemFont(ofSize: 60)
        emoji.textAlignment = .center
        emoji.translatesAutoresizingMaskIntoConstraints = false

        let title = DesignFactory.makePrimaryLabel(text: "Ничего не найдено", size: 18)
        title.textAlignment = .center

        let subtitle = DesignFactory.makeSecondaryLabel(text: "Попробуйте другой запрос", size: 14)
        subtitle.textAlignment = .center

        [emoji, title, subtitle].forEach { v.addSubview($0) }

        emoji.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-40)
        }

        title.snp.makeConstraints {
            $0.top.equalTo(emoji.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }

        subtitle.snp.makeConstraints {
            $0.top.equalTo(title.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
        }

        return v
    }()

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = AppColor.background
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Layout
    private func setupLayout() {
        [titleLabel,
         searchBar,
         homeContentView,
         historyTableView,
         resultsTableView,
         emptyStateView].forEach {
            addSubview($0)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
        }

        searchBar.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(8)
        }

        homeContentView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        historyTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }

        resultsTableView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        emptyStateView.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(25)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
    }
}

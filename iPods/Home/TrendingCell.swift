//
//  TrendingCell.swift
//  iPods
//
//  Created by Administration  on 28/04/26.
//


// TrendingCell.swift
// iPods

import UIKit

final class TrendingCell: UITableViewCell {

    static let reuseID = "TrendingCell"

    // MARK: - Callback
    var onSelect: ((Int) -> Void)?

    // MARK: - UI
    private let collectionView: UICollectionView

    // MARK: - Data
    private var data: [PodcastFull] = []

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup
    private func setupUI() {
        backgroundColor = .black
        contentView.backgroundColor = .black
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.isScrollEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(
            TrendingItemCell.self,
            forCellWithReuseIdentifier: TrendingItemCell.reuseID
        )
        contentView.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Configure
    func configure(with podcasts: [PodcastFull]) {
        self.data = podcasts
        collectionView.reloadData()
    }
}

// MARK: - UICollectionView

extension TrendingCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrendingItemCell.reuseID,
            for: indexPath
        ) as! TrendingItemCell
        cell.configure(with: data[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 12
        let totalWidth = UIScreen.main.bounds.width - 32 - spacing
        let width = totalWidth / 2
        return CGSize(width: width, height: width + 50)
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        onSelect?(indexPath.item)
    }
}

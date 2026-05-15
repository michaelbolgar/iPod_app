//
//  TrendingCell.swift
//  iPods
//
//  Created by Administration  on 16/04/26.
//

import UIKit

final class TrendingCell: UITableViewCell {

    static let reuseID = "TrendingCell"

    // MARK: - Callbacks
    var onSelect: ((Int) -> Void)? //for conflicts lmao

    // MARK: - UI
    private let collectionView: UICollectionView

    // MARK: - Data
    private var data: [PodcastFull] = []

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical

        let spacing: CGFloat = 12
        layout.minimumLineSpacing = spacing
        layout.minimumInteritemSpacing = spacing

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
        collectionView.register(TrendingItemCell.self,
                                forCellWithReuseIdentifier: TrendingItemCell.reuseID)

        contentView.addSubview(collectionView)

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    // MARK: - Configure
    func configure(with data: [PodcastFull]) {
        self.data = data
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
            for: indexPath) as! TrendingItemCell
        guard indexPath.item < data.count else { return cell }
        cell.configure(with: data[indexPath.item])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let spacing: CGFloat = 12
        let width = (collectionView.frame.width - spacing) / 2
        return CGSize(width: width, height: width + 50)
    }

    // тап по каточке
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        onSelect?(indexPath.item)
    }
}

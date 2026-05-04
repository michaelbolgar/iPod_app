//
//  TrendingCell.swift
//  iPods
//
//  Created by Administration  on 16/04/26.
//

import UIKit

final class TrendingCell: UITableViewCell {

    static let reuseID = "TrendingCell"

    var onSelect: ((Podcast) -> Void)?

    private var data: [Podcast] = []

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 12
        layout.minimumLineSpacing = 12

        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = .black
        cv.isScrollEnabled = false
        cv.dataSource = self
        cv.delegate = self
        cv.register(TrendingItemCell.self,
                    forCellWithReuseIdentifier: TrendingItemCell.reuseID)
        return cv
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        backgroundColor = .black
        selectionStyle = .none

        contentView.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            collectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Config

    func configure(with data: [Podcast]) {
        self.data = data
        collectionView.reloadData()
    }
}
extension TrendingCell: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        data.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: TrendingItemCell.reuseID,
            for: indexPath
        ) as? TrendingItemCell else {
            return UICollectionViewCell()
        }

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

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {

        onSelect?(data[indexPath.item])
    }
}

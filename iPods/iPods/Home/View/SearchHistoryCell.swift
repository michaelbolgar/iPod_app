//
//  SearchHistoryCell.swift
//  iPods
//
//  Created by Hoshimov Matin on 20/04/26.
//

import UIKit
import SnapKit

final class SearchHistoryCell: UITableViewCell {
    static let reuseID = "SearchHistoryCell"

    private let iconView: UIImageView = {
        let iv = UIImageView(image: UIImage(systemName: "clock"))
        iv.tintColor = AppColor.secondary
        return iv
    }()

    private let queryLabel = DesignFactory.makeSecondaryLabel(text: "", size: 15)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        [iconView, queryLabel].forEach { contentView.addSubview($0) }

        iconView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(16)
        }

        queryLabel.snp.makeConstraints {
            $0.leading.equalTo(iconView.snp.trailing).offset(10)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().offset(-16)
        }
    }

    func configure(query: String) {
        queryLabel.text = query
    }
}

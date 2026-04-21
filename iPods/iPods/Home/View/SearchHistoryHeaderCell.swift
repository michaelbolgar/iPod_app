//
//  SearchHistoryHeaderCell.swift
//  iPods
//
//  Created by Hoshimov Matin on 20/04/26.
//

import UIKit
import SnapKit
import DesignSys

final class SearchHistoryHeaderCell: UITableViewCell {
    static let reuseID = "SearchHistoryHeaderCell"

    private let titleLabel = DesignFactory.makePrimaryLabel(text: "Recent Searches", size: 18)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
    }
}

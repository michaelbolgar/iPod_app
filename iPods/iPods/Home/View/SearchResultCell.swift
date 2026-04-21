//
//  SearchResultCell.swift
//  iPods
//
//  Created by Hoshimov Matin on 16/04/26.
//

import UIKit
import SnapKit
import DesignSys

final class SearchResultCell: UITableViewCell {
    static let reuseID = "SearchResultCell"

    private let podcastImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 8
        iv.backgroundColor = AppColor.secondary
        return iv
    }()

    private let titleLabel = DesignFactory.makePrimaryLabel(text: "", size: 16)
    private let authorLabel = DesignFactory.makeSecondaryLabel(text: "", size: 13)

    private let separatorLine: UIView = {
        let v = UIView()
        v.backgroundColor = AppColor.secondary.withAlphaComponent(0.4)
        return v
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        setupLayout()
    }

    required init?(coder: NSCoder) { fatalError() }

    private func setupLayout() {
        [podcastImageView, titleLabel, authorLabel, separatorLine].forEach {
            contentView.addSubview($0)
        }

        podcastImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(52)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.leading.equalTo(podcastImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview().offset(-16)
        }

        authorLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(4)
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalTo(titleLabel)
        }

        separatorLine.snp.makeConstraints {
            $0.leading.equalTo(titleLabel)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.height.equalTo(0.5)
        }
    }

    func configure(title: String, author: String) {
        titleLabel.text = title
        authorLabel.text = author
    }
}

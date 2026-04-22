//
//  SectionHeaderView.swift
//  iPods
//
//  Created by Administration  on 18/04/26.
//


import UIKit

final class SectionHeaderView: UIView {

    // MARK: - Init

    init(title: String) {
        super.init(frame: .zero)
        backgroundColor = .black
        setupLabel(title)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setupLabel(_ title: String) {
        let label = UILabel()
        label.text = title
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}
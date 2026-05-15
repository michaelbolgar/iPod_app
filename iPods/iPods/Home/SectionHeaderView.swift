//
//  SectionHeaderView.swift
//  iPods
//
//  Created by Administration  on 18/04/26.
//

import UIKit
import DesignSys

final class SectionHeaderView: UIView {

    // MARK: - Init

    init(title: String, symbolName: String? = nil) {
        super.init(frame: .zero)
        backgroundColor = .black
        setupLabel(title, symbolName: symbolName)
    }

    required init?(coder: NSCoder) { fatalError() }

    // MARK: - Setup

    private func setupLabel(_ title: String, symbolName: String?) {
        let label = UILabel()
        label.textColor = .white
        label.font = AppFonts.primaryBold(size: 18)
        label.translatesAutoresizingMaskIntoConstraints = false

        if let symbolName {
            let config = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold)
            let icon = UIImage(systemName: symbolName, withConfiguration: config)?
                .withTintColor(UIColor(red: 1, green: 0.6, blue: 0.1, alpha: 1), renderingMode: .alwaysOriginal)
            let attachment = NSTextAttachment()
            attachment.image = icon
            attachment.bounds = CGRect(x: 0, y: -2, width: 18, height: 18)

            let attributed = NSMutableAttributedString(attachment: attachment)
            attributed.append(NSAttributedString(string: "  \(title)"))
            label.attributedText = attributed
        } else {
            label.text = title
        }

        addSubview(label)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8)
        ])
    }
}

//
//  ViewController.swift
//  iPods
//
//  Created by Михаил Болгар on 13.04.2026.
//

import UIKit

class ViewController: UIViewController {

    private let titleLabel = DesignFactory.makePrimaryLabel(text: "Hello, team", size: 24)
    private let subtitleLabel = DesignFactory.makeSecondaryLabel(text: "Let's code this app", size: 14)
    private let startButton = DesignFactory.makePrimaryButton(title: "Play Now")

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        setupView()
    }

    private func setupView() {
        [titleLabel, subtitleLabel, startButton].forEach { view.addSubview($0) }

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 60),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),

            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            subtitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -32),

            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            startButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}

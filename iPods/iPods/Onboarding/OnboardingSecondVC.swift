import UIKit
import SnapKit
import DesignSys

final class OnboardingSecondVC: UIViewController {

    var onContinue: (() -> Void)?

    // MARK: - Constants

    private enum Layout {
        static let titleTop: CGFloat = 161
        static let titleHorizontal: CGFloat = 36
        static let titleToFeaturesSpacing: CGFloat = 48
        static let buttonBottomInset: CGFloat = 56
        static let buttonHorizontalInset: CGFloat = 52
        static let buttonHeight: CGFloat = 58
        static let iconContainerWidth: CGFloat = 78
        static let iconContainerHeight: CGFloat = 74
        static let iconContainerCorner: CGFloat = 16
        static let iconSize: CGFloat = 32
        static let iconTextSpacing: CGFloat = 16
        static let featureStackSpacing: CGFloat = 28
        static let textStackSpacing: CGFloat = 4
    }

    private static let iconBackgroundColor = UIColor(red: 33/255, green: 26/255, blue: 13/255, alpha: 1)

    // MARK: - UI

    private let titleLabel: UILabel = {
        let label = DesignFactory.makePrimaryLabel(text: "Everything You Need", size: 40)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let featuresStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = Layout.featureStackSpacing
        return stack
    }()

    private let continueButton = DesignFactory.makePrimaryButton(title: "Continue")

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        setupFeatures()
        setupLayout()
        continueButton.addTarget(self, action: #selector(didTapContinue), for: .touchUpInside)
    }

    // MARK: - Setup

    private func setupFeatures() {
        let items: [(String, String, String)] = [
            ("onboardingHeart", "Personalized for You", "Recommendations based on your preferences"),
            ("onboardingDownload", "Listen Offline", "Download episodes and enjoy your favorite podcasts anytime"),
            ("onboardingBell", "Never Miss Out", "Get notified about new episodes from your favorite shows")
        ]

        items.forEach { imageName, title, description in
            featuresStack.addArrangedSubview(makeFeatureRow(imageName: imageName, title: title, description: description))
        }
    }

    private func makeFeatureRow(imageName: String, title: String, description: String) -> UIView {
        let container = UIView()

        let iconContainer = UIView()
        iconContainer.backgroundColor = OnboardingSecondVC.iconBackgroundColor
        iconContainer.layer.cornerRadius = Layout.iconContainerCorner

        let iconView = UIImageView()
        iconView.image = UIImage(named: imageName)
        iconView.contentMode = .scaleAspectFit
        iconView.tintColor = AppColor.primary
        iconContainer.addSubview(iconView)

        iconView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(Layout.iconSize)
        }

        let featureTitleLabel = DesignFactory.makePrimaryLabel(text: title, size: 20)
        let descLabel = DesignFactory.makeSecondaryLabel(text: description, size: 16)
        descLabel.numberOfLines = 0

        let textStack = UIStackView(arrangedSubviews: [featureTitleLabel, descLabel])
        textStack.axis = .vertical
        textStack.spacing = Layout.textStackSpacing

        container.addSubview(iconContainer)
        container.addSubview(textStack)

        iconContainer.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(Layout.iconContainerWidth)
            $0.height.equalTo(Layout.iconContainerHeight)
        }

        textStack.snp.makeConstraints {
            $0.leading.equalTo(iconContainer.snp.trailing).offset(Layout.iconTextSpacing)
            $0.trailing.top.bottom.equalToSuperview()
        }

        return container
    }

    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(titleLabel)
        view.addSubview(featuresStack)
        view.addSubview(continueButton)

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Layout.titleTop)
            $0.leading.trailing.equalToSuperview().inset(Layout.titleHorizontal)
        }

        featuresStack.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Layout.titleToFeaturesSpacing)
            $0.leading.trailing.equalToSuperview().inset(Layout.titleHorizontal)
        }

        continueButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Layout.buttonBottomInset)
            $0.leading.trailing.equalToSuperview().inset(Layout.buttonHorizontalInset)
            $0.height.equalTo(Layout.buttonHeight)
        }
    }

    // MARK: - Actions

    @objc private func didTapContinue() {
        onContinue?()
    }
}

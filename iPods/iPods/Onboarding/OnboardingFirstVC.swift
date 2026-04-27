import UIKit
import SnapKit
import DesignSys

final class OnboardingFirstVC: UIViewController {

    var onGetStarted: (() -> Void)?

    // MARK: - Constants

    private enum Layout {
        static let heroTop: CGFloat = 181
        static let heroOffsetX: CGFloat = -24
        static let heroWidth: CGFloat = 500
        static let heroHeight: CGFloat = 706
        static let titleTop: CGFloat = 220
        static let titleHorizontal: CGFloat = 16
        static let subtitleSpacing: CGFloat = 16
        static let buttonBottomInset: CGFloat = 56
        static let buttonHorizontalInset: CGFloat = 52
        static let buttonHeight: CGFloat = 58
    }

    // MARK: - UI

    private let heroImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(named: "onboardingHero")
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        return iv
    }()

    private let titleLabel: UILabel = {
        let label = DesignFactory.makePrimaryLabel(text: "Welcome to\nPodcast", size: 60)
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()

    private let subtitleLabel: UILabel = {
        let label = DesignFactory.makeSecondaryLabel(text: "Discover, listen, and explore thousands\nof podcasts tailored to your interests", size: 22)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private let getStartedButton = DesignFactory.makePrimaryButton(title: "Get Started")

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = AppColor.background
        setupLayout()
        getStartedButton.addTarget(self, action: #selector(didTapGetStarted), for: .touchUpInside)
    }

    // MARK: - Layout

    private func setupLayout() {
        view.addSubview(heroImageView)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(getStartedButton)

        heroImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Layout.heroTop)
            $0.centerX.equalToSuperview().offset(Layout.heroOffsetX)
            $0.width.equalTo(Layout.heroWidth)
            $0.height.equalTo(Layout.heroHeight)
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(Layout.titleTop)
            $0.leading.trailing.equalToSuperview().inset(Layout.titleHorizontal)
        }

        subtitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(Layout.subtitleSpacing)
            $0.leading.trailing.equalToSuperview().inset(Layout.titleHorizontal)
        }

        getStartedButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(Layout.buttonBottomInset)
            $0.leading.trailing.equalToSuperview().inset(Layout.buttonHorizontalInset)
            $0.height.equalTo(Layout.buttonHeight)
        }
    }

    // MARK: - Actions

    @objc private func didTapGetStarted() {
        onGetStarted?()
    }
}

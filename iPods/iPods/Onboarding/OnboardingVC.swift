import UIKit

final class OnboardingVC: UIPageViewController {

    static let hasSeenOnboardingKey = "hasSeenOnboarding"

    private let firstVC = OnboardingFirstVC()
    private let secondVC = OnboardingSecondVC()

    override func viewDidLoad() {
        super.viewDidLoad()
        firstVC.onGetStarted = { [weak self] in
            guard let self else { return }
            setViewControllers([secondVC], direction: .forward, animated: true)
        }

        secondVC.onContinue = { [weak self] in
            self?.finish()
        }

        setViewControllers([firstVC], direction: .forward, animated: false)
    }

    private func finish() {
        UserDefaults.standard.set(true, forKey: OnboardingVC.hasSeenOnboardingKey)

        guard let scene = view.window?.windowScene,
              let delegate = scene.delegate as? SceneDelegate else { return }
        delegate.showHome()
    }
}

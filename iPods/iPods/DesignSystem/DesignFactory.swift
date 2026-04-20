import UIKit

public final class DesignFactory {

    // MARK: - Labels
    public static func makePrimaryLabel(text: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = AppColor.white
        label.font = AppFonts.primary(size: size)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    public static func makeSecondaryLabel(text: String, size: CGFloat) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = AppColor.secondary
        label.font = AppFonts.secondary(size: size)
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

    // MARK: - Buttons
    public static func makePrimaryButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = AppColor.primary
        button.setTitle(title, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 12
        button.titleLabel?.font = AppFonts.primaryBold(size: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
}

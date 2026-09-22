import UIKit

final class SectionHeaderView: UICollectionReusableView {

    static let reuseID = "SectionHeaderView"

    private let titleLabel = UILabel()
    private let seeAllButton = UIButton(type: .system)

    var onSeeAllTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        titleLabel.font = .systemFont(ofSize: 17, weight: .bold)
        titleLabel.textColor = AppColors.primaryText

        seeAllButton.setTitle("See all", for: .normal)
        seeAllButton.setTitleColor(AppColors.gradientStart, for: .normal)
        seeAllButton.titleLabel?.font = .systemFont(ofSize: 13, weight: .semibold)
        seeAllButton.addTarget(self, action: #selector(seeAllTapped), for: .touchUpInside)

        [titleLabel, seeAllButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: seeAllButton.leadingAnchor, constant: -8),

            seeAllButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            seeAllButton.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("SectionHeaderView is created in code")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        onSeeAllTapped = nil
    }

    func configure(title: String) {
        titleLabel.text = title
    }

    @objc private func seeAllTapped() {
        onSeeAllTapped?()
    }
}
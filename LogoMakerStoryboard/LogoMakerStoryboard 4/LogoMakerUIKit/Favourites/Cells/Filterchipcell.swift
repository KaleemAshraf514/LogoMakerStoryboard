import UIKit

final class FilterChipCell: UICollectionViewCell {
    static let reuseID = "FilterChipCell"

    @IBOutlet private weak var titleLabel: UILabel?
    private let programmaticTitleLabel = UILabel()
    private var activeTitleLabel: UILabel { titleLabel ?? programmaticTitleLabel }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureContainer()
        configureProgrammaticLabel()
    }

    required init?(coder: NSCoder) { super.init(coder: coder) }

    override func awakeFromNib() {
        super.awakeFromNib()
        configureContainer()
        configureLabel(titleLabel)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel?.text = nil
        programmaticTitleLabel.text = nil
    }

    private func configureContainer() {
        contentView.layer.cornerRadius = 16
        contentView.clipsToBounds = true
    }

    private func configureProgrammaticLabel() {
        configureLabel(programmaticTitleLabel)
        programmaticTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(programmaticTitleLabel)
        NSLayoutConstraint.activate([
            programmaticTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 14),
            programmaticTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -14),
            programmaticTitleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            programmaticTitleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }

    private func configureLabel(_ label: UILabel?) {
        label?.font = .systemFont(ofSize: 13, weight: .medium)
        label?.textAlignment = .center
        label?.numberOfLines = 1
    }

    func configure(title: String, isSelected: Bool) {
        let label = activeTitleLabel
        label.text = title
        label.textColor = isSelected ? .white : AppColors.primaryText
        label.font = .systemFont(ofSize: 13, weight: isSelected ? .semibold : .medium)
        contentView.backgroundColor = isSelected ? AppColors.gradientStart : AppColors.cardBackground
    }
}
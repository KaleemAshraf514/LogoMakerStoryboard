import UIKit

/// Lightweight card for a real template thumbnail used on Home and Favourites.
/// The heart is a real per-template favourite control (not a subcategory favourite).
final class HomeTemplatePreviewCell: UICollectionViewCell {

    static let reuseID = "HomeTemplatePreviewCell"

    private let imageView = UIImageView()
    private let activityIndicator = UIActivityIndicatorView(style: .medium)
    private let heartButton = UIButton(type: .system)

    private var imageLoadTask: URLSessionDataTask?
    private var representedURL: URL?

    var onHeartTapped: (() -> Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)

        contentView.backgroundColor = AppColors.cardBackground
        contentView.layer.cornerRadius = 12
        contentView.layer.masksToBounds = true

        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = AppColors.cardBackground

        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true

        heartButton.translatesAutoresizingMaskIntoConstraints = false
        heartButton.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.9)
        heartButton.layer.cornerRadius = 16
        heartButton.tintColor = AppColors.favouriteHeartInactive
        heartButton.accessibilityLabel = "Favourite"
        heartButton.addTarget(self, action: #selector(heartTapped), for: .touchUpInside)

        contentView.addSubview(imageView)
        contentView.addSubview(activityIndicator)
        contentView.addSubview(heartButton)

        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            heartButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 7),
            heartButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -7),
            heartButton.widthAnchor.constraint(equalToConstant: 32),
            heartButton.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    required init?(coder: NSCoder) { fatalError("HomeTemplatePreviewCell is created in code") }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageLoadTask?.cancel(); imageLoadTask = nil; representedURL = nil; onHeartTapped = nil
        imageView.image = nil; imageView.tintColor = nil; activityIndicator.stopAnimating(); updateHeart(isFavourite: false)
    }

    func configure(url: URL, isFavourite: Bool) {
        imageLoadTask?.cancel(); representedURL = url; imageView.image = nil; imageView.tintColor = nil
        imageView.contentMode = .scaleAspectFill; activityIndicator.startAnimating(); updateHeart(isFavourite: isFavourite)
        imageLoadTask = ImageLoader.shared.load(url) { [weak self] image in
            guard let self, self.representedURL == url else { return }
            self.activityIndicator.stopAnimating()
            if let image { self.imageView.image = image; self.imageView.contentMode = .scaleAspectFill }
            else {
                let config = UIImage.SymbolConfiguration(pointSize: 26, weight: .medium)
                self.imageView.image = UIImage(systemName: "photo", withConfiguration: config)
                self.imageView.tintColor = AppColors.secondaryText; self.imageView.contentMode = .center
            }
        }
    }

    func updateHeart(isFavourite: Bool) {
        heartButton.setImage(UIImage(systemName: isFavourite ? "heart.fill" : "heart"), for: .normal)
        heartButton.tintColor = isFavourite ? AppColors.favouriteHeartActive : AppColors.favouriteHeartInactive
        heartButton.accessibilityValue = isFavourite ? "Selected" : "Not selected"
    }

    @objc private func heartTapped() { onHeartTapped?() }
}
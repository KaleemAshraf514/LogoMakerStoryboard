import UIKit

final class GradientView: UIView {
    override class var layerClass: AnyClass { CAGradientLayer.self }
    private var gradientLayer: CAGradientLayer { layer as! CAGradientLayer }
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure(colors: [AppColors.gradientStart, AppColors.gradientEnd], start: CGPoint(x: 0, y: 0), end: CGPoint(x: 1, y: 1))
    }
    init(colors: [UIColor], start: CGPoint = CGPoint(x: 0, y: 0), end: CGPoint = CGPoint(x: 1, y: 1)) {
        super.init(frame: .zero); configure(colors: colors, start: start, end: end)
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configure(colors: [AppColors.gradientStart, AppColors.gradientEnd], start: CGPoint(x: 0, y: 0), end: CGPoint(x: 1, y: 1))
    }
    private func configure(colors: [UIColor], start: CGPoint, end: CGPoint) {
        gradientLayer.colors = colors.map { $0.cgColor }; gradientLayer.startPoint = start; gradientLayer.endPoint = end
    }
}

final class GradientButton: UIControl {
    let titleLabel = UILabel()
    private let gradient = GradientView(colors: [AppColors.gradientStart, AppColors.gradientEnd])
    init(title: String, font: UIFont = .systemFont(ofSize: 15, weight: .semibold)) {
        super.init(frame: .zero)
        titleLabel.text = title; titleLabel.font = font; titleLabel.textColor = .white; titleLabel.textAlignment = .center; titleLabel.isUserInteractionEnabled = false
        gradient.isUserInteractionEnabled = false; gradient.translatesAutoresizingMaskIntoConstraints = false; titleLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(gradient); addSubview(titleLabel)
        NSLayoutConstraint.activate([
            gradient.topAnchor.constraint(equalTo: topAnchor), gradient.bottomAnchor.constraint(equalTo: bottomAnchor),
            gradient.leadingAnchor.constraint(equalTo: leadingAnchor), gradient.trailingAnchor.constraint(equalTo: trailingAnchor),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor), titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
        layer.masksToBounds = true
    }
    required init?(coder: NSCoder) { super.init(coder: coder) }
    override func layoutSubviews() { super.layoutSubviews(); layer.cornerRadius = bounds.height / 2 }
    override var isHighlighted: Bool { didSet { alpha = isHighlighted ? 0.85 : 1 } }
}

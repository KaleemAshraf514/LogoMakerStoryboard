import UIKit

final class CategoryChipCell: UICollectionViewCell {
    static let reuseID = "CategoryChipCell"
    private let iconContainer = UIView(), iconImageView = UIImageView(), fallbackLabel = UILabel(), nameLabel = UILabel()
    private let fallbackGradientLayer = CAGradientLayer()
    override init(frame: CGRect) {
        super.init(frame: frame); contentView.backgroundColor = .clear
        iconContainer.translatesAutoresizingMaskIntoConstraints=false; iconContainer.layer.cornerRadius=16; iconContainer.layer.masksToBounds=true
        fallbackGradientLayer.cornerRadius=16; fallbackGradientLayer.isHidden=true; iconContainer.layer.insertSublayer(fallbackGradientLayer,at:0)
        iconImageView.translatesAutoresizingMaskIntoConstraints=false; iconImageView.contentMode = .scaleAspectFit; iconImageView.clipsToBounds=true; iconImageView.layer.cornerRadius=16
        fallbackLabel.translatesAutoresizingMaskIntoConstraints=false; fallbackLabel.font=.systemFont(ofSize:18,weight:.semibold); fallbackLabel.textColor=.white; fallbackLabel.textAlignment=.center; fallbackLabel.isHidden=true
        nameLabel.translatesAutoresizingMaskIntoConstraints=false; nameLabel.font=.systemFont(ofSize:10,weight:.medium); nameLabel.textColor=AppColors.secondaryText; nameLabel.textAlignment=.center; nameLabel.numberOfLines=1; nameLabel.lineBreakMode = .byClipping
        contentView.addSubview(iconContainer); contentView.addSubview(nameLabel); iconContainer.addSubview(iconImageView); iconContainer.addSubview(fallbackLabel)
        NSLayoutConstraint.activate([
            iconContainer.topAnchor.constraint(equalTo:contentView.topAnchor,constant:2), iconContainer.centerXAnchor.constraint(equalTo:contentView.centerXAnchor), iconContainer.widthAnchor.constraint(equalToConstant:56), iconContainer.heightAnchor.constraint(equalToConstant:56),
            iconImageView.leadingAnchor.constraint(equalTo:iconContainer.leadingAnchor), iconImageView.trailingAnchor.constraint(equalTo:iconContainer.trailingAnchor), iconImageView.topAnchor.constraint(equalTo:iconContainer.topAnchor), iconImageView.bottomAnchor.constraint(equalTo:iconContainer.bottomAnchor),
            fallbackLabel.leadingAnchor.constraint(equalTo:iconContainer.leadingAnchor), fallbackLabel.trailingAnchor.constraint(equalTo:iconContainer.trailingAnchor), fallbackLabel.topAnchor.constraint(equalTo:iconContainer.topAnchor), fallbackLabel.bottomAnchor.constraint(equalTo:iconContainer.bottomAnchor),
            nameLabel.topAnchor.constraint(equalTo:iconContainer.bottomAnchor,constant:3), nameLabel.leadingAnchor.constraint(equalTo:contentView.leadingAnchor,constant:2), nameLabel.trailingAnchor.constraint(equalTo:contentView.trailingAnchor,constant:-2), nameLabel.heightAnchor.constraint(equalToConstant:14)
        ])
    }
    required init?(coder:NSCoder){ fatalError("CategoryChipCell is created in code") }
    override func layoutSubviews(){ super.layoutSubviews(); fallbackGradientLayer.frame=iconContainer.bounds }
    override func prepareForReuse(){ super.prepareForReuse(); nameLabel.text=nil; iconImageView.image=nil; iconImageView.isHidden=false; fallbackLabel.text=nil; fallbackLabel.isHidden=true; fallbackGradientLayer.colors=nil; fallbackGradientLayer.isHidden=true }
    func configure(category:TemplateCategory,isSelected:Bool){
        nameLabel.text=category.Category_Display_Name; nameLabel.font=.systemFont(ofSize:10,weight:isSelected ? .semibold:.medium)
        let preferred=isSelected ? category.selectedIconAssetName:category.iconAssetName
        let image=loadImage(named:preferred) ?? loadImage(named:category.iconAssetName)
        if let image { iconImageView.image=image; iconImageView.isHidden=false; fallbackLabel.isHidden=true; fallbackGradientLayer.isHidden=true }
        else {
            iconImageView.isHidden=true; fallbackLabel.text=String(category.Category_Display_Name.prefix(1)).uppercased(); fallbackLabel.isHidden=false
            fallbackGradientLayer.colors=isSelected ? [UIColor(hex:"#7C3AED").cgColor,UIColor(hex:"#7C3AED").cgColor] : category.gradientColors.map{UIColor(hex:$0).cgColor}
            fallbackGradientLayer.startPoint=CGPoint(x:0,y:0); fallbackGradientLayer.endPoint=CGPoint(x:1,y:1); fallbackGradientLayer.isHidden=false; iconContainer.layoutIfNeeded(); fallbackGradientLayer.frame=iconContainer.bounds
        }
        accessibilityLabel=category.Category_Display_Name; accessibilityTraits=isSelected ? [.button,.selected]:[.button]
    }
    private func loadImage(named assetName:String?)->UIImage?{
        guard let assetName,!assetName.isEmpty else{return nil}
        if let image=UIImage(named:assetName){return image.withRenderingMode(.alwaysOriginal)}
        let rawName="\(assetName)Raw"
        if let p=Bundle.main.path(forResource:rawName,ofType:"png"),let image=UIImage(contentsOfFile:p){return image.withRenderingMode(.alwaysOriginal)}
        return nil
    }
}

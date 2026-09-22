import UIKit

final class CreateOptionCell:UICollectionViewCell{
 static let reuseID="CreateOptionCell"
 @IBOutlet private weak var iconContainer:UIView!
 @IBOutlet private weak var iconLabel:UILabel!
 @IBOutlet private weak var nameLabel:UILabel!
 private let iconImageView=UIImageView()
 override func awakeFromNib(){super.awakeFromNib(); iconContainer.layer.cornerRadius=18; iconContainer.clipsToBounds=true; iconContainer.backgroundColor=.clear; iconLabel.isHidden=true
  iconImageView.translatesAutoresizingMaskIntoConstraints=false; iconImageView.contentMode=.scaleAspectFit; iconImageView.clipsToBounds=true; iconContainer.addSubview(iconImageView)
  NSLayoutConstraint.activate([iconImageView.leadingAnchor.constraint(equalTo:iconContainer.leadingAnchor,constant:4),iconImageView.trailingAnchor.constraint(equalTo:iconContainer.trailingAnchor,constant:-4),iconImageView.topAnchor.constraint(equalTo:iconContainer.topAnchor,constant:4),iconImageView.bottomAnchor.constraint(equalTo:iconContainer.bottomAnchor,constant:-4)])
  nameLabel.textAlignment=.center; nameLabel.textColor=AppColors.primaryText; nameLabel.font=.systemFont(ofSize:13,weight:.medium); nameLabel.adjustsFontSizeToFitWidth=true; nameLabel.minimumScaleFactor=0.8
 }
 override func prepareForReuse(){super.prepareForReuse(); iconImageView.image=nil; nameLabel.text=nil}
 func configure(imageName:String,title:String){iconLabel.isHidden=true; iconContainer.backgroundColor=.clear; iconImageView.image=UIImage(named:imageName); nameLabel.text=title}
}
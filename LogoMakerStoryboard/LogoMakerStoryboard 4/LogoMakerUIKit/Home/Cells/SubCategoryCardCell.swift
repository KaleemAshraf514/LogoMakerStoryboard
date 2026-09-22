import UIKit

final class SubCategoryCardCell: UICollectionViewCell {
    static let reuseID = "SubCategoryCardCell"
    @IBOutlet private weak var thumbnailContainer: UIView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var countLabel: UILabel!
    @IBOutlet private weak var newBadgeLabel: UILabel!
    @IBOutlet private weak var heartButton: UIButton!
    @IBOutlet private weak var thumbnailImageView: UIImageView!
    var onHeartTapped: (() -> Void)?
    private var imageLoadTask: URLSessionDataTask?
    private var representedThumbnailURL: URL?

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = .clear; contentView.backgroundColor = AppColors.cardBackground; contentView.layer.cornerRadius = 14; contentView.layer.masksToBounds = true
        thumbnailContainer.layer.cornerRadius = 10; thumbnailContainer.clipsToBounds = true; thumbnailContainer.backgroundColor = AppColors.screenBackground
        thumbnailImageView.clipsToBounds = true; thumbnailImageView.contentMode = .scaleAspectFill
        nameLabel.font = .systemFont(ofSize: 14, weight: .semibold); nameLabel.textColor = AppColors.primaryText; nameLabel.numberOfLines = 1
        countLabel.font = .systemFont(ofSize: 12, weight: .regular); countLabel.textColor = AppColors.secondaryText; countLabel.numberOfLines = 1
        newBadgeLabel.font = .systemFont(ofSize: 9, weight: .bold); newBadgeLabel.textColor = .white; newBadgeLabel.textAlignment = .center
        newBadgeLabel.layer.cornerRadius = 6; newBadgeLabel.clipsToBounds = true; newBadgeLabel.backgroundColor = AppColors.newBadge
        heartButton.tintColor = AppColors.favouriteHeartInactive
    }
    override func prepareForReuse() {
        super.prepareForReuse(); imageLoadTask?.cancel(); imageLoadTask=nil; representedThumbnailURL=nil; onHeartTapped=nil
        nameLabel.text=nil; countLabel.text=nil; newBadgeLabel.isHidden=true; showPlaceholder()
    }
    override func layoutSubviews() { super.layoutSubviews(); contentView.bringSubviewToFront(thumbnailContainer); thumbnailContainer.bringSubviewToFront(heartButton); thumbnailContainer.bringSubviewToFront(newBadgeLabel) }
    func configure(subcategory: TemplateSubCategory, isFavourite: Bool) {
        nameLabel.text=subcategory.Subcategory_DisplayName; countLabel.text="\(subcategory.Subcategory_Item_Count) templates"; newBadgeLabel.isHidden = !(subcategory.isNew ?? false)
        heartButton.tintColor = isFavourite ? AppColors.favouriteHeartActive : AppColors.favouriteHeartInactive
        heartButton.setImage(UIImage(systemName:isFavourite ? "heart.fill":"heart"),for:.normal)
        imageLoadTask?.cancel(); imageLoadTask=nil; representedThumbnailURL=nil; showPlaceholder()
        guard let s=subcategory.Subcategory_Thumbnail_URL, let url=URL(string:s), let scheme=url.scheme?.lowercased(), scheme=="https" || scheme=="http" else{return}
        representedThumbnailURL=url
        imageLoadTask=ImageLoader.shared.load(url){[weak self] image in guard let self,self.representedThumbnailURL==url,let image else{return}; self.thumbnailImageView.image=image; self.thumbnailImageView.contentMode=.scaleAspectFill}
    }
    static func preferredHeight(for width:CGFloat)->CGFloat { let contentWidth=max(0,width-16); let thumbnailHeight=contentWidth*8.0/15.0; return ceil(8+thumbnailHeight+6+18+2+16+8) }
    private func showPlaceholder(){let config=UIImage.SymbolConfiguration(pointSize:28,weight:.medium); thumbnailImageView.image=UIImage(systemName:"photo",withConfiguration:config); thumbnailImageView.tintColor=AppColors.secondaryText; thumbnailImageView.contentMode=.center}
    @IBAction private func heartTapped(_ sender:Any){onHeartTapped?()}
}
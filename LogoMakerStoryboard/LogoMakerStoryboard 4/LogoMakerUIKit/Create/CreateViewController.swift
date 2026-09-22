import UIKit

final class CreateViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    private struct Option { let imageName:String; let title:String }
    private let options:[Option] = [
        .init(imageName:"CategoryLogo",title:"Logo"), .init(imageName:"CategoryPoster",title:"Poster"),
        .init(imageName:"CategoryIGStory",title:"IG Story"), .init(imageName:"CategoryInvitation",title:"Invitation"),
        .init(imageName:"CategoryFlyers",title:"Flyer"), .init(imageName:"CategoryBusinessCards",title:"Business Card")
    ]
    override func viewDidLoad(){
        super.viewDidLoad(); view.backgroundColor=AppColors.screenBackground; titleLabel.text="What Would You Like\nTo Create?"; titleLabel.textColor=AppColors.primaryText
        collectionView.backgroundColor=.clear; collectionView.dataSource=self; collectionView.delegate=self
        if let layout=collectionView.collectionViewLayout as? UICollectionViewFlowLayout { layout.estimatedItemSize = .zero; layout.minimumLineSpacing=18; layout.minimumInteritemSpacing=12; layout.sectionInset=UIEdgeInsets(top:8,left:20,bottom:24,right:20) }
    }
    override func viewWillAppear(_ animated:Bool){super.viewWillAppear(animated); navigationController?.setNavigationBarHidden(true,animated:animated)}
}
extension CreateViewController:UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView:UICollectionView,numberOfItemsInSection section:Int)->Int{options.count}
    func collectionView(_ collectionView:UICollectionView,cellForItemAt indexPath:IndexPath)->UICollectionViewCell{
        guard options.indices.contains(indexPath.item),let cell=collectionView.dequeueReusableCell(withReuseIdentifier:CreateOptionCell.reuseID,for:indexPath) as? CreateOptionCell else{return UICollectionViewCell()}
        let option=options[indexPath.item]; cell.configure(imageName:option.imageName,title:option.title); return cell
    }
    func collectionView(_ collectionView:UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath)->CGSize{
        let columns:CGFloat=collectionView.bounds.width >= 600 ? 4:3; let width=floor((collectionView.bounds.width-40-12*(columns-1))/columns); return CGSize(width:max(80,width),height:104)
    }
    func collectionView(_ collectionView:UICollectionView,didSelectItemAt indexPath:IndexPath){collectionView.deselectItem(at:indexPath,animated:true); guard options.indices.contains(indexPath.item) else{return}; UnderConstruction.show(on:self,feature:options[indexPath.item].title)}
}

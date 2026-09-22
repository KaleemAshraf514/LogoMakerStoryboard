import Foundation

final class FavouritesManager {
    static let shared = FavouritesManager()
    static let didChangeNotification = Notification.Name("FavouritesManager.didChange")
    private let subcategoryStorageKey = "com.logomaker.favouriteTemplateIDs.v2"
    private let legacyStorageKey = "com.logomaker.favouriteSubcategoryIDs"
    private let templateStorageKey = "com.logomaker.favouriteTemplateURLs.v1"
    private var favouriteSubcategoryIDs: Set<String>
    private var legacyFavouriteIDs: Set<String>
    private var favouriteTemplateURLs: Set<String>
    private init() {
        favouriteSubcategoryIDs = Set(UserDefaults.standard.stringArray(forKey: subcategoryStorageKey) ?? [])
        legacyFavouriteIDs = Set(UserDefaults.standard.stringArray(forKey: legacyStorageKey) ?? [])
        favouriteTemplateURLs = Set(UserDefaults.standard.stringArray(forKey: templateStorageKey) ?? [])
    }
    func isTemplateFavourite(_ url: URL) -> Bool { favouriteTemplateURLs.contains(url.absoluteString) }
    func toggleTemplate(_ url: URL) {
        let id=url.absoluteString
        if favouriteTemplateURLs.contains(id) { favouriteTemplateURLs.remove(id) } else { favouriteTemplateURLs.insert(id) }
        persist()
    }
    func removeTemplate(_ url: URL) { guard favouriteTemplateURLs.remove(url.absoluteString) != nil else { return }; persist() }
    func favouritedTemplates(from categories: [TemplateCategory]) -> [(category: TemplateCategory, subcategory: TemplateSubCategory, url: URL)] {
        guard !favouriteTemplateURLs.isEmpty else { return [] }; var result:[(TemplateCategory,TemplateSubCategory,URL)]=[]
        for category in categories.sorted(by: {$0.Category_Index < $1.Category_Index}) {
            for subcategory in category.SubCategories.sorted(by: {$0.SubCategory_Index < $1.SubCategory_Index}) {
                for url in subcategory.templateThumbnailURLs where favouriteTemplateURLs.contains(url.absoluteString) { result.append((category,subcategory,url)) }
            }
        }; return result
    }
    func isFavourite(_ subcategory: TemplateSubCategory, in category: TemplateCategory) -> Bool {
        favouriteSubcategoryIDs.contains(stableID(category: category, subcategory: subcategory)) || legacyFavouriteIDs.contains(subcategory.Subcategory_S3_Name)
    }
    func toggle(_ subcategory: TemplateSubCategory, in category: TemplateCategory) {
        let id=stableID(category: category, subcategory: subcategory)
        if favouriteSubcategoryIDs.contains(id) { favouriteSubcategoryIDs.remove(id) }
        else if legacyFavouriteIDs.contains(subcategory.Subcategory_S3_Name) { legacyFavouriteIDs.remove(subcategory.Subcategory_S3_Name) }
        else { favouriteSubcategoryIDs.insert(id) }
        persist()
    }
    func remove(_ subcategory: TemplateSubCategory, in category: TemplateCategory) {
        favouriteSubcategoryIDs.remove(stableID(category: category, subcategory: subcategory)); legacyFavouriteIDs.remove(subcategory.Subcategory_S3_Name); persist()
    }
    func favouritedSubcategories(from categories: [TemplateCategory]) -> [(category: TemplateCategory, subcategory: TemplateSubCategory)] {
        var result:[(TemplateCategory,TemplateSubCategory)]=[]
        for category in categories { for subcategory in category.SubCategories where isFavourite(subcategory,in:category) { result.append((category,subcategory)) } }
        return result
    }
    private func stableID(category: TemplateCategory, subcategory: TemplateSubCategory) -> String { "\(category.Category_S3_Name)::\(subcategory.Subcategory_S3_Name)" }
    private func persist() {
        UserDefaults.standard.set(Array(favouriteSubcategoryIDs).sorted(), forKey: subcategoryStorageKey)
        UserDefaults.standard.set(Array(legacyFavouriteIDs).sorted(), forKey: legacyStorageKey)
        UserDefaults.standard.set(Array(favouriteTemplateURLs).sorted(), forKey: templateStorageKey)
        NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
    }
}

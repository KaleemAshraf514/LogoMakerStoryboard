import Foundation

struct TemplatesResponse: Codable { let AppData: AppDataContent }
struct AppDataContent: Codable { let AppVersion: String; let Templates: [TemplatesVersionBlock] }
struct TemplatesVersionBlock: Codable { let TemplatesVersion: String; let Categories: [TemplateCategory] }

struct TemplateCategory: Codable {
    let Category_Display_Name: String
    let Category_S3_Name: String
    let Category_Aspect_Ratio: String
    let Category_Index: Int
    let Free_Templates: Int
    let isDoubleSided: Bool
    let Category_Color: [String]?
    let Category_Free: Bool
    let SubCategories: [TemplateSubCategory]
    var gradientColors: [UIColorHex] { if let colors = Category_Color, !colors.isEmpty { return colors }; return ["#7B2FF7", "#F02FC2"] }
    var isVisibleInTemplateBrowser: Bool {
        let hiddenNames: Set<String> = ["stickers", "shapes"]
        let d = Category_Display_Name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let s = Category_S3_Name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        return !hiddenNames.contains(d) && !hiddenNames.contains(s)
    }
    var iconAssetName: String? {
        let d = Category_Display_Name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        let s = Category_S3_Name.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        switch (d,s) {
        case ("logos", _), (_, "logos"): return "CategoryLogo"
        case ("flyers", _), (_, "flyers"): return "CategoryFlyers"
        case ("posters", _), (_, "posters"): return "CategoryPoster"
        case ("business cards", _), (_, "businesscard"): return "CategoryBusinessCards"
        case ("invitations", _), (_, "invitations"): return "CategoryInvitation"
        case ("instagram story", _), ("ig story", _), (_, "instagramstory"), (_, "igstory"): return "CategoryIGStory"
        default: return nil
        }
    }
    var selectedIconAssetName: String? { guard let normal = iconAssetName else { return nil }; return "\(normal)Selected" }
}

struct TemplateSubCategory: Codable {
    let Subcategory_DisplayName: String
    let Subcategory_S3_Name: String
    let Subcategory_Item_Count: Int
    let SubCategory_Index: Int
    let isNew: Bool?
    let Subcategory_Free_Templates: Int?
    let Subcategory_Free: Bool?
    let Subcategory_Thumbnail_URL: String?
    var templateThumbnailURLs: [URL] {
        guard Subcategory_Item_Count > 0, let first = Subcategory_Thumbnail_URL,
              let markerRange = first.range(of: "-1.", options: .backwards) else {
            if let first = Subcategory_Thumbnail_URL, let url = URL(string: first) { return [url] }
            return []
        }
        let prefix = String(first[..<markerRange.lowerBound])
        let suffix = String(first[markerRange.lowerBound...]).dropFirst(2)
        return (1...Subcategory_Item_Count).compactMap { URL(string: "\(prefix)-\($0)\(suffix)") }
    }
}

enum TemplateBrowserTopic: String, CaseIterable {
    case business = "Business", sports = "Sports", food = "Food", music = "Music", travel = "Travel"
    fileprivate var keywords: [String] {
        switch self {
        case .business: return ["business","real estate","law","attorney","advertising","ecommerce","trading","finance","account","insurance","security","factory","architecture","education","health care","hospital","cleaning services","event planners"]
        case .sports: return ["sports","fitness","yoga","snooker","equestrian","fishing"]
        case .food: return ["food","restaurant","coffee","chocolate","honey","coconut","sugarcane","poultry"]
        case .music: return ["music","dj","dance","night club"]
        case .travel: return ["travel","hotel","beach","safari","desert","sea"]
        }
    }
}
extension TemplateSubCategory {
    func matchesBrowserTopic(_ topic: TemplateBrowserTopic) -> Bool {
        let normalized = normalizedBrowserName
        if topic == .business, normalized == "it" { return true }
        return topic.keywords.contains { normalized.contains($0) }
    }
    func browserNameContainsAny(_ keywords: [String]) -> Bool { let normalized = normalizedBrowserName; return keywords.contains { normalized.contains($0) } }
    private var normalizedBrowserName: String { Subcategory_DisplayName.trimmingCharacters(in: .whitespacesAndNewlines).lowercased() }
}
typealias UIColorHex = String

import UIKit

final class MainTabBarController: UITabBarController {
    enum Tab: Int { case home = 0, create = 1, favourites = 2 }
    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = AppColors.cardBackground
        tabBar.standardAppearance = appearance
        tabBar.scrollEdgeAppearance = appearance
        tabBar.tintColor = AppColors.gradientStart
        tabBar.unselectedItemTintColor = AppColors.secondaryText
        viewControllers?.forEach { controller in
            if let nav = controller as? UINavigationController {
                nav.navigationBar.prefersLargeTitles = false
                nav.navigationBar.tintColor = AppColors.primaryText
            }
        }
    }
    func selectTab(_ tab: Tab) {
        guard let viewControllers, viewControllers.indices.contains(tab.rawValue) else { return }
        selectedIndex = tab.rawValue
    }
}

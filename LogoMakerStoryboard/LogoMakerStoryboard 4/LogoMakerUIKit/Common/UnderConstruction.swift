import UIKit

enum UnderConstruction {
    static func alert(feature: String? = nil) -> UIAlertController {
        let message: String
        if let feature, !feature.isEmpty { message = "\(feature) is under development. Please check back soon!" }
        else { message = "This feature is under development. Please check back soon!" }
        let alert = UIAlertController(title: "Coming Soon", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        return alert
    }
    static func show(on viewController: UIViewController, feature: String? = nil) {
        guard viewController.presentedViewController == nil else { return }
        viewController.present(alert(feature: feature), animated: true)
    }
}

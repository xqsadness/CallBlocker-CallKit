
import Foundation
import SwiftUI
import StoreKit

class MyAlert: UIAlertController{
    static var shared = MyAlert()
    func setBackgroundColor(color: Color) {
        if let bgView = self.view.subviews.first, let groupView = bgView.subviews.first, let contentView = groupView.subviews.first {
            contentView.backgroundColor = UIColor(color)
            groupView.layer.cornerRadius = 20
        }
    }
    
    func setTitle(font: UIFont?, color: Color?) {
        guard let title = self.title else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, attributeString.length))
        }
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(titleColor)],//3
                                          range: NSMakeRange(0, attributeString.length))
        }
        self.setValue(attributeString, forKey: "attributedTitle")
    }
    
    func setMessage(font: UIFont?, color: Color?) {
        guard let title = self.message else { return }
        let attributeString = NSMutableAttributedString(string: title)//1
        if let titleFont = font {
            attributeString.addAttributes([NSAttributedString.Key.font : titleFont],//2
                                          range: NSMakeRange(0, attributeString.length))
        }
        if let titleColor = color {
            attributeString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor(titleColor)],//3
                                          range: NSMakeRange(0, attributeString.length))
        }
        self.setValue(attributeString, forKey: "attributedMessage")
    }

    func setTint(color: UIColor) {
        self.view.tintColor = color
    }
    
    func showAlert(alert: MyAlert) {
        alert.setTint(color: UIColor(Color("AccentColor")))
        if let controller = UIApplication.shared.topMostViewController() {
            if controller.presentedViewController == nil{
                controller.present(alert, animated: true)
            }else{
                controller.presentedViewController?.present(alert, animated: true)
            }
        }
    }
    func share(item: [Any]){
        let activityViewController = UIActivityViewController(activityItems: item, applicationActivities: nil)
        if let viewController = UIApplication.shared.topMostViewController(){
            if let pop = activityViewController.popoverPresentationController{
                pop.sourceView = viewController.view
                pop.sourceRect = CGRect(x: viewController.view.center.x, y: viewController.view.center.y, width: 0, height: 0)
            }
            DispatchQueue.main.async {
                viewController.present(activityViewController, animated: true, completion: nil)
            }
           
        }
    }
    
    static func showRate(){
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
}


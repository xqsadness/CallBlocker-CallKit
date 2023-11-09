

import Foundation
import SwiftUI
import MessageUI

class Mail: NSObject, MFMailComposeViewControllerDelegate {
    static var shared = Mail()
    func show(){
        let composeVC = MFMailComposeViewController()
        composeVC.mailComposeDelegate = self
        composeVC.setToRecipients([CONSTANT.SHARED.INFO_APP.EMAIL_CONTRACT])
        composeVC.setSubject("Customer Care")
        composeVC.setMessageBody("Dear Deverloper,\n", isHTML: false)
        UIApplication.shared.key?.rootViewController?.present(composeVC, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

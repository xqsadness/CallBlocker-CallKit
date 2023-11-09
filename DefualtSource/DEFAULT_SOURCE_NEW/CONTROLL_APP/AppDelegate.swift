//
//  AppDelegate.swift
//  DefaultProject
//
//  Created by CycTrung on 04/06/2023.
//

import Foundation
import Firebase
import GoogleMobileAds
import AppTrackingTransparency

class AppDelegate: NSObject, UIApplicationDelegate{
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options:  [.alert, .badge, .sound]) { (allowed, error) in
            if #available(iOS 14.0, *) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                    self.appTracking()
                })
            }
        }
        return true
    }
    func appTracking(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            ATTrackingManager.requestTrackingAuthorization { status in
               
            }
        }
    }
    func applicationWillTerminate(_ application: UIApplication) {
//        if UserDefaults.standard.bool(forKey: "firstTerminate") == false && User.activeMore() && !User.shared.isPremium{
//            LocalNotification.shared.setLocalNotification(title: "Upgrade Premium Free Now!", subtitle: "Upgrade Premium without purchased", body: "Tap here to get free premium now!", when: 1, id: "cyc.moreapp")
//            UserDefaults.standard.setValue(true, forKey: "firstTerminate")
//       }
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print(deviceToken)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print(error.localizedDescription)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate  {
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .sound, .badge])
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//        if response.notification.request.identifier == "cyc.moreapp" {
//            Constant.myNotification.showMoreApp = true
//        }else if response.notification.request.identifier == "cyc.download"{
//            Constant.myNotification.showDownload = true
//        }
        completionHandler()
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) { }
    
}



extension UIApplicationDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        print("Successfully registered for notifications!")
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
}

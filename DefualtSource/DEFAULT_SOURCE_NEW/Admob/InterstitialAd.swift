//
//  InterstitialAd.swift
//  SwiftUIMobileAds
//
//  Created by Patrick Haertel on 5/23/21.
//

import GoogleMobileAds
import SwiftUI
import UIKit

class InterstitialAd: NSObject, GADFullScreenContentDelegate {
    var interstitialAd: GADInterstitialAd?
    
    static let shared = InterstitialAd()
    
    func loadAd(withAdUnitId id: String, completion: @escaping(_ result: Bool)->Void) {
        let req = GADRequest()
        GADInterstitialAd.load(withAdUnitID: id, request: req) { interstitialAd, err in
            if let err = err {
                print("Failed to load ad with error: \(err)")
                completion(false)
                return
            }
            debugPrint("LOAD INTERSIAL")
            self.interstitialAd = interstitialAd
            self.interstitialAd?.fullScreenContentDelegate = self
            completion(true)
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        NotificationCenter.default.post(name: Notification.Name("dismissInterstitial"), object: nil)
        self.interstitialAd = nil
        self.loadAd(withAdUnitId: CONSTANT.SHARED.ADS.INTERSTITIAL_ID) { result in
            //
        }
    }
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        self.interstitialAd = nil
        self.loadAd(withAdUnitId: CONSTANT.SHARED.ADS.INTERSTITIAL_ID) { result in
            //
        }
    }
    func show(){
        if let ad = InterstitialAd.shared.interstitialAd{
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                do {
                    if var view = UIApplication.shared.topMostViewController(){
                        do {
                            if let presentedView = view.presentedViewController {
                                view = presentedView
                            }
                            try ad.canPresent(fromRootViewController: view)
                            ad.present(fromRootViewController: view)
                        }catch let error{
                            print(error)
                        }
                    }
                }
                catch let erorr {
                    LocalNotification.shared.message("Ads load failed!",.info)
                    self.interstitialAd = nil
                    self.loadAd(withAdUnitId: CONSTANT.SHARED.ADS.INTERSTITIAL_ID) { result in
                        //
                    }
                }
            })
        }
        else{
            InterstitialAd.shared.loadAd(withAdUnitId: CONSTANT.SHARED.ADS.INTERSTITIAL_ID) { result in
                if let ad = InterstitialAd.shared.interstitialAd, var view = UIApplication.shared.topMostViewController(){
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                        do {
                            if let presentedView = view.presentedViewController {
                                view = presentedView
                            }
                            try ad.canPresent(fromRootViewController: view)
                            ad.present(fromRootViewController: view)
                        }catch {
                            LocalNotification.shared.message("Ads load failed!",.info)
                            self.interstitialAd = nil
                            self.loadAd(withAdUnitId: CONSTANT.SHARED.ADS.INTERSTITIAL_ID) { result in
                                //
                            }
                        }
                    })
                }
            }
        }
    }
}

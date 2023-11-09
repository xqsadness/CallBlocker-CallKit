//
//  RewardedAd.swift
//  SwiftUIMobileAds
//
//  Created by Patrick Haertel on 5/23/21.
//

import GoogleMobileAds
import SwiftUI
import UIKit

class RewardedAd: NSObject, GADFullScreenContentDelegate{
    static let shared = RewardedAd()
    var rewardedAd: GADRewardedAd?
    var callback: (()->Void)?

    func loadAd(withAdUnitId id: String, completion: @escaping (_ result: Bool)->Void) {
        if self.rewardedAd != nil{
            completion(true)
            return
        }
        let req = GADRequest()
        GADRewardedAd.load(withAdUnitID: id, request: req) { rewardedAd, err in
            if let err = err {
                print("Failed to load ad with error: \(err)")
                completion(false)
                return
            }
            debugPrint("LOAD REWARDED")
            self.rewardedAd = rewardedAd
            self.rewardedAd?.fullScreenContentDelegate = self
            completion(true)
        }
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        callback?()
        self.rewardedAd = nil
        self.loadAd(withAdUnitId:  CONSTANT.SHARED.ADS.REWARDED_ID) { result in
            //
        }
    }
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        callback?()
        self.rewardedAd = nil
        self.loadAd(withAdUnitId:   CONSTANT.SHARED.ADS.REWARDED_ID) { result in
            //
        }
    }
    
    func show(completion: @escaping (_ result: Bool)->Void){
        if let ad = RewardedAd.shared.rewardedAd{
            LocalNotification.shared.message("Ads ready!", .info)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                do {
                    if var view = UIApplication.shared.topMostViewController(){
                        if let presentedView = view.presentedViewController {
                            view = presentedView
                        }
                        try ad.canPresent(fromRootViewController: view)
                        ad.present(fromRootViewController: view) {
                            
                        }
                    }
                }
                catch {
                    LocalNotification.shared.message("Ads load failed! Allow Download FREE!", .info)
                    self.rewardedAd = nil
                    self.loadAd(withAdUnitId:  CONSTANT.SHARED.ADS.REWARDED_ID) { result in
                        //
                    }
                }
            })
        }
        else{
            LocalNotification.shared.message("Loading ads...", .info)
            RewardedAd.shared.loadAd(withAdUnitId:  CONSTANT.SHARED.ADS.REWARDED_ID){ bool in
                if let ad = RewardedAd.shared.rewardedAd, var view = UIApplication.shared.topMostViewController(){
                    do {
                        if let presentedView = view.presentedViewController {
                            view = presentedView
                        }
                        try ad.canPresent(fromRootViewController: view)
                        ad.present(fromRootViewController: view) {
                          
                        }
                    }
                    catch {
                        LocalNotification.shared.message("Ads load failed! Allow Download FREE!",.info)
                        self.rewardedAd = nil
                        self.loadAd(withAdUnitId:  CONSTANT.SHARED.ADS.REWARDED_ID) { result in
                            //
                        }
                    }
                }else{
                    completion(true)
                }
            }
        }
    }
}

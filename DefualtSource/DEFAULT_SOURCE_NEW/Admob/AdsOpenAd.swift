

import GoogleMobileAds
import SwiftUI
import UIKit

class AdsOpenAd: NSObject, GADFullScreenContentDelegate{
    var adsOpenAd: GADAppOpenAd?
    static let shared = AdsOpenAd()
    
    func loadAd(withAdUnitId id: String, completion: @escaping (_ result: Bool)->Void) {
        let req = GADRequest()
        GADAppOpenAd.load(withAdUnitID: CONSTANT.SHARED.ADS.OPEN_APP_ID,
                          request: req,
                          orientation: UIInterfaceOrientation.portrait,
                          completionHandler: {[weak self] (appAds, err)  in
            
            if let err = err {
                print("Failed to load ad with error: \(err)")
                completion(false)
                return
            }
            
            self?.adsOpenAd = appAds
            self?.adsOpenAd?.fullScreenContentDelegate = self
            completion(true)
        })
    }
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        NotificationCenter.default.post(name: Notification.Name("dismissAdsOpen"), object: nil)

    }
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        NotificationCenter.default.post(name: Notification.Name("dismissAdsOpen"), object: nil)
    }
    func show(){
        AdsOpenAd.shared.loadAd(withAdUnitId:  CONSTANT.SHARED.ADS.OPEN_APP_ID) { result in
            if let ad = AdsOpenAd.shared.adsOpenAd, var view = UIApplication.shared.key?.rootViewController{
                do {
                    if let presentedView = view.presentedViewController {
                        view = presentedView
                    }
                    try ad.canPresent(fromRootViewController: view)
                    ad.present(fromRootViewController: view)
                    UserDefaults.standard.setValue(TimeInterval(Date().timeIntervalSince1970), forKey: "timeAdsOpen")
                }catch let error{
                    print(error)
                }
            }
        }
    }
}

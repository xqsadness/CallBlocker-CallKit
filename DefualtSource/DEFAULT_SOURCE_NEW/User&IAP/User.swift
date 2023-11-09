//
//  USER.swift
//  DEFAULT_SOURCE
//
//  Created by CycTrung on 02/03/2023.
//

import Foundation
import SwiftUI

class User: ObservableObject{
    static var shared = User()
    @Published var timeExpired: Int = 0
    @Published var isPremium: Bool = true
    @AppStorage(CONSTANT.COUNT_DOWNLOAD) var countDownload = 0
    @AppStorage(CONSTANT.TIME_ADS_OPEN) var timeAdsOpen = 0
    @AppStorage(CONSTANT.COUNT_SHOW_RATE) var countShowRate = 0
    @AppStorage("user_email") var userEmail:String = ""
    @AppStorage("user_UID") var userUID:String = ""
    
    func getUser(){
        User.shared.timeExpired = UserDefaults.standard.integer(forKey: CONSTANT.EXPIRED_PREMIUM)
        if TimeInterval(User.shared.timeExpired) > Date().timeIntervalSince1970{
            User.shared.isPremium = true
        }
        else{
            if timeExpired != 0 && UserDefaults.standard.bool(forKey: CONSTANT.IS_AUTO_RENEWS) == true{
                IAPHandler.shared.restorePurchase()
            }
            else{
                User.shared.isPremium = false
            }
        }
        
        print("\(Date().timeIntervalSince1970) - \(timeExpired) ")
    }
    
    static func activeNewDesign()->Bool{ return CONSTANT.SHARED.DESIGN.ACTIVE_NEW_DESIGN }
    
    static func activeMoreApp()->Bool{ return CONSTANT.SHARED.DESIGN.ACTIVE_MORE_APP }
    
    static func activeHidden()->Bool { return CONSTANT.SHARED.DESIGN.ACTIVE_HIDDEN }
    
    static func allowDownload()-> Bool {
        if User.shared.isPremium{
            return true
        }
        return User.shared.countDownload < CONSTANT.SHARED.ADS.LIMIT_FREE_WITH_REWARDED
    }
    
    static func isShowAdsOpen() -> Bool{
        if User.shared.isPremium || !CONSTANT.SHARED.ADS.ENABLE_OPEN_APP{
            return false
        }else{
            if User.shared.timeAdsOpen == 0{
                User.shared.timeAdsOpen = Int(TimeInterval(Date().timeIntervalSince1970))
                return false
            }
            else{
                if Int(TimeInterval(Date().timeIntervalSince1970)) - User.shared.timeAdsOpen > 0 {
                    User.shared.timeAdsOpen = Int(TimeInterval(Date().timeIntervalSince1970))
                    return true
                }
                else{
                    return false
                }
            }
        }
    }
    
    static func isShowInterstitial()->Bool{
        if User.shared.isPremium || !CONSTANT.SHARED.ADS.ENABLE_INTERSTITIAL{
            return false
        }
        return true
    }
    
    static func isShowBanner()->Bool{
        if User.shared.isPremium || !CONSTANT.SHARED.ADS.ENABLE_BANNER{
            return false
        }
        return true
    }
    
    static func isShowRewarded()->Bool{
        print(User.shared.isPremium)
        if User.shared.isPremium || !CONSTANT.SHARED.ADS.ENABLE_REWARDED{
            print(User.shared.isPremium)
            return false
        }
        return true
    }
    
    static func isShowNative()->Bool{
        if User.shared.isPremium || !CONSTANT.SHARED.ADS.ENABLE_NATIVE{
            return false
        }
        return true
    }
    
    static func isShowRate()->Bool{
        if CONSTANT.SHARED.DESIGN.ACTIVE_SHOW_RATE_WHEN_OPEN_APP == false{
            return false
        }
       
        if User.shared.countShowRate >= 16{
            return false
        }
        if ((User.shared.countShowRate + 1) % 5 == 0){
            User.shared.countShowRate += 1
            return true
        }
        else{
            User.shared.countShowRate += 1
            return false
        }
    }
}


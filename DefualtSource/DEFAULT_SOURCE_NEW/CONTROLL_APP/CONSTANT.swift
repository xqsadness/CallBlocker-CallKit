//
//  CONSTANT.swift
//  DEFAULT_SOURCE
//
//  Created by CycTrung on 01/03/2023.
//

import Foundation
import FirebaseDatabase
import SwiftUI

class CONSTANT{
    static var SHARED = CONSTANT()
    
    static var USING_MANIFEST = true
    static var MANIFEST_URL = "/manifest/test/v1_0"
    
    var OBSERVER_MANIFEST: Any?
    
    @AppStorage("TIME_INSTALLED_APP") var TIME_INSTALLED_APP = 0
    @AppStorage("SAVE_VERSION_APP") var SAVE_VERSION_APP = ""
    
    func load(_ completion: @escaping (()->Void)){
        if CONSTANT.USING_MANIFEST && Network.connectedToNetwork(){
            self.OBSERVER_MANIFEST = Database.database().reference().child(CONSTANT.MANIFEST_URL).observe(.value){snapshot in
                if !snapshot.exists(){
                    debugPrint("MANIFEST URL NOT FOULD!")
                    return
                }
                let json = JSON(snapshot.value as Any)
                self.pareManifest(json, completion: {
                    completion()
                })
            }
        }
        else {
            if let manifestPath = Bundle.main.path(forResource: "temp_manifest", ofType: "json"){
                if let data = NSData(contentsOfFile: manifestPath) {
                    do {
                        let json = try JSON(data: data as Data, options: JSONSerialization.ReadingOptions.allowFragments)
                        self.pareManifest(json, completion: {
                            completion()
                        })
                    } catch _ {
                        debugPrint("error")
                    }
                }
            }
        }
    }
    
    //Init
    var VERSION_APP = [VERSION_APP_STRUCT]()
    var INFO_APP = INFO_APP_STRUCT()
    var IAP: [IAP_STRUCT] = [
        .init(KEY: "week", PRICE: "0.99$", PRODUCT_ID: "cyc.trung.musi.week", DESCRIPTION:  "Plan auto-renews for 0.99$ / week", TITLE: "WEEKLY", PERCENT_DISCOUNT: "", OTHER_INFOMATION: ""),
        .init(KEY: "month", PRICE: "2.99$", PRODUCT_ID: "cyc.trung.musi.month", DESCRIPTION:  "Plan auto-renews for 2.99$ / month", TITLE: "MONTHY", PERCENT_DISCOUNT: "-25%", OTHER_INFOMATION: ""),
        .init(KEY: "year", PRICE: "9.99$", PRODUCT_ID: "cyc.trung.musi.year", DESCRIPTION:  "Plan auto-renews for 9.99$ / year", TITLE: "YEARLY", PERCENT_DISCOUNT: "-81%", OTHER_INFOMATION: "")
    ]
    var ADS = ADS_STRUCT()
    var DESIGN = DESIGN_STRUCT()
    var URL = URL_STRUCT()
    var APP_NAVIGATION = APP_NAVIGATION_STRUCT()
    var ART: [Artist] = []
    var GENRES: [Genres] = []
}

struct VERSION_APP_STRUCT{
    var ID = ""
    var TIME_REALEASE = 0
    var IS_STILL_USED = false
    var PATH_VERSION = ""
}

struct IAP_STRUCT{
    var KEY: String
    var PRICE: String
    var PRODUCT_ID: String
    var DESCRIPTION: String
    var TITLE: String
    var PERCENT_DISCOUNT: String
    var OTHER_INFOMATION: String
}

struct INFO_APP_STRUCT{
    var VERIFY_RECEIPT = "https://buy.itunes.apple.com/verifyReceipt"
    var SECRET_PASS = "1b1f1309201b4ef68f50396547f67ef9"
    var SUBCRIPTION_TEXT = "Subscription automatically renews unless auto-renew is turned off at least 24-hours before the end of the current period. Account will be charged for renewal within 24-hours prior to the end of the current period, and identify the cost of the renewal. Subscriptions may be managed by the user and auto-renewal may be turned off in your Apple ID Account Settings after purchases"
    var PRIVACY = "https://telegra.ph/Privacy-Policy-10-15-52"
    var TERM = "https://telegra.ph/Terms--Conditions-10-15-2"
    var EMAIL_CONTRACT = "vuphoapp2021@gmail.com"
    var APPSTORE_URL = "https://apps.apple.com/us/app/mymusic-offline-music-player/id1588911860"
    var KEYDECRYPTEBTEXT = "28 02 98 16 87 b6 bc 2c 93 89 c3 34 9f dc 17 fb 3d fb ba 62 24 af fb 76 76 e1 33 79 26 cd d6 02"
}

struct ADS_STRUCT{
    var APP_ID_RECOMMEND = "1440611372"
    var BANNER_ID = "ca-app-pub-3940256099942544/2934735716"
    var INTERSTITIAL_ID = "ca-app-pub-3940256099942544/4411468910"
    var REWARDED_ID = "ca-app-pub-3940256099942544/1712485313"
    var OPEN_APP_ID = "ca-app-pub-3940256099942544/5662855259"
    var NATIVE_ID = "ca-app-pub-3940256099942544/3986624511"
    
    var ENABLE_BANNER = false
    var ENABLE_INTERSTITIAL = false
    var ENABLE_REWARDED = true
    var ENABLE_OPEN_APP = true
    var ENABLE_NATIVE = false
    var ENABLE_RECOMMEND = true
    
    var LIMIT_FREE_WITH_REWARDED = 999999 //Đơn vị: Số lần
    var INTERVAL_INTERSTITIAL = 5 //Đơn vị: Số lần
    var INTERVAL_APP_OPEN = 900 //Đơn vị: Giây
}

struct DESIGN_STRUCT{
    var ACTIVE_NEW_DESIGN = true
    var ACTIVE_HIDDEN = true
    var ACTIVE_MORE_APP = true
    var ACTIVE_SHOW_RATE_WHEN_OPEN_APP = true
    var ENABLE_GIFT = true
    var ENABLE_FANPAGE = true
    var ENABLE_CACHE = false
    var ENABLE_SIGNATURE = true
    var ENABLE_ADVANCED_MODE_EDITOR = true
}

struct URL_STRUCT{
    var PATH_GIFTCODE = "giftcode"
    var LINK_FANAPGE = "http://www.facebook.com/MetaVietnam"
    var LINK_SCHEME_FANPAGE = "fb://profile/108824017345866"
    var FORM_FEEBACK = "https://forms.gle/HMGm1gUSSpWFkEGQ8"
    var LINK_GARAGEBAND = "https://apps.apple.com/us/app/garageband/id408709785"
    var LINK_API_CATEGORY = "https://ring.daktech.co/list_category"
    var LINK_LIST_RINGTONE = "https://ring.daktech.co/ringtone?sortby=download"
    var LINK_CATEGORY_WALLPAPER = "https://aiby.mobi/widget/json/v1.54/release/wallpapers.json"
    var LINK_CATEGORY_LIVE_WALLPAPER = "https://aiby.mobi/widget/json/v1.54/release/liveWallpapers.json"
    var LINK_SEARCH_RINGTONE = "https://ring.daktech.co/ringtone?sortby=download&title="
}

struct APP_NAVIGATION_STRUCT{
    var IS_SHOW_ALWAYS = false
    var ENABLE = true
    var TITLE = "TITLE"
    var MESSAGE = "MESSAGE"
    var IMAGE_URL = "https://is2-ssl.mzstatic.com/image/thumb/Purple116/v4/96/33/fc/9633fc94-4ff0-e3aa-7669-5b081cefad2f/AppIconMac-0-2x_U007euniversal-0-4-0-0-0-85-220-0.png/246x0w.webp"
    var URL = "https://apps.apple.com/us/app/mymusic-offline-music-player/id1588911860"
    var BUTTON_NAME = "OK"
    var COLOR_BACKGROUND = "ffffff"
    var COLOR_TEXT = "000000"
    var COLOR_BUTTON_BACKGROUND = "00CC51"
    var COLOR_BUTTON_TEXT = "ffffff"
}

struct Genres: Identifiable, Hashable{
    var id: UUID
    var name: String = ""
}

struct Artist: Identifiable, Hashable{
    var id: UUID
    var name: String = ""
    var subscribers: String = ""
    var thumbnails: String = ""
}

extension CONSTANT{
    func pareManifest(_ json: JSON, completion: @escaping ()->Void){
        //VERSION_APP
        let vers = json["VERSION_APP"]
        var listVer: [VERSION_APP_STRUCT] = []
        for (_, json) : (String, JSON) in vers{
            listVer.append(VERSION_APP_STRUCT(ID: json["ID"].stringValue, TIME_REALEASE: json["TIME_REALEASE"].intValue, IS_STILL_USED: json["IS_STILL_USED"].boolValue, PATH_VERSION: json["PATH_VERSION"].stringValue))
        }
        self.VERSION_APP = listVer
        if SAVE_VERSION_APP == ""{
            SAVE_VERSION_APP = self.VERSION_APP.last?.PATH_VERSION ?? ""
        }
        else if SAVE_VERSION_APP != self.VERSION_APP.last?.PATH_VERSION{
            if let index = self.VERSION_APP.firstIndex(where: { ver in
                return SAVE_VERSION_APP == ver.PATH_VERSION
            }){
                if VERSION_APP[index].IS_STILL_USED{
                    self.loadOldVersion(path: VERSION_APP[index].PATH_VERSION) {
                        completion()
                    }
                    return
                }
                else{
                    SAVE_VERSION_APP = self.VERSION_APP.last?.PATH_VERSION ?? ""
                }
            }
            else{
                SAVE_VERSION_APP = self.VERSION_APP.last?.PATH_VERSION ?? ""
            }
        }
        if SAVE_VERSION_APP != CONSTANT.MANIFEST_URL && SAVE_VERSION_APP != "" && CONSTANT.USING_MANIFEST{
            self.loadOldVersion(path: SAVE_VERSION_APP) {
                completion()
            }
            return
        }
        parseOther(json)
        completion()
    }
    
    func parseOther(_ json: JSON){
        //INFO_APP
        let info_app = json["INFO_APP"]
        self.INFO_APP.VERIFY_RECEIPT = info_app["VERIFY_RECEIPT"].stringValue
        self.INFO_APP.APPSTORE_URL = info_app["APPSTORE_URL"].stringValue
        self.INFO_APP.EMAIL_CONTRACT = info_app["EMAIL_CONTRACT"].stringValue
        self.INFO_APP.PRIVACY = info_app["PRIVACY"].stringValue
        self.INFO_APP.TERM = info_app["TERM"].stringValue
        self.INFO_APP.SECRET_PASS = info_app["SECRET_PASS"].stringValue
        self.INFO_APP.SUBCRIPTION_TEXT = info_app["SUBCRIPTION_TEXT"].stringValue
        self.INFO_APP.KEYDECRYPTEBTEXT = info_app["KEYDECRYPTEBTEXT"].stringValue
        //IAP
        let iaps = json["IAP"]
        var list: [IAP_STRUCT] = []
        for (_, json) : (String, JSON) in iaps{
            list.append(IAP_STRUCT(KEY: json["KEY"].stringValue, PRICE: json["PRICE"].stringValue, PRODUCT_ID: json["PRODUCT_ID"].stringValue, DESCRIPTION: json["DESCRIPTION"].stringValue, TITLE: json["TITLE"].stringValue, PERCENT_DISCOUNT: json["PERCENT_DISCOUNT"].stringValue, OTHER_INFOMATION: json["OTHER_INFOMATION"].stringValue))
        }
        self.IAP = list
        //ADS
        let ads = json["ADS"]
        self.ADS.BANNER_ID = ads["BANNER_ID"].stringValue
        self.ADS.INTERSTITIAL_ID = ads["INTERSTITIAL_ID"].stringValue
        self.ADS.REWARDED_ID = ads["REWARDED_ID"].stringValue
        self.ADS.OPEN_APP_ID = ads["OPEN_APP_ID"].stringValue
        self.ADS.NATIVE_ID = ads["NATIVE_ID"].stringValue
        self.ADS.ENABLE_BANNER = ads["ENABLE_BANNER"].boolValue
        self.ADS.ENABLE_INTERSTITIAL = ads["ENABLE_INTERSTITIAL"].boolValue
        self.ADS.ENABLE_REWARDED = ads["ENABLE_REWARDED"].boolValue
        self.ADS.ENABLE_OPEN_APP = ads["ENABLE_OPEN_APP"].boolValue
        self.ADS.ENABLE_NATIVE = ads["ENABLE_NATIVE"].boolValue
        self.ADS.LIMIT_FREE_WITH_REWARDED = ads["LIMIT_FREE_WITH_REWARDED"].intValue
        self.ADS.INTERVAL_INTERSTITIAL = ads["INTERVAL_INTERSTITIAL"].intValue
        self.ADS.INTERVAL_APP_OPEN = ads["INTERVAL_APP_OPEN"].intValue
        self.ADS.APP_ID_RECOMMEND = ads["APP_ID_RECOMMEND"].stringValue
        self.ADS.ENABLE_RECOMMEND = ads["ENABLE_RECOMMEND"].boolValue
        //Design
        let design = json["DESIGN"]
        self.DESIGN.ACTIVE_HIDDEN = design["ACTIVE_HIDDEN"].boolValue
        self.DESIGN.ACTIVE_NEW_DESIGN = design["ACTIVE_NEW_DESIGN"].boolValue
        self.DESIGN.ACTIVE_MORE_APP = design["ACTIVE_MORE_APP"].boolValue
        self.DESIGN.ACTIVE_SHOW_RATE_WHEN_OPEN_APP = design["ACTIVE_SHOW_RATE_WHEN_OPEN_APP"].boolValue
        self.DESIGN.ENABLE_GIFT = design["ENABLE_GIFT"].boolValue
        self.DESIGN.ENABLE_FANPAGE = design["ENABLE_FANPAGE"].boolValue
        self.DESIGN.ENABLE_CACHE = design["ENABLE_CACHE"].boolValue
        self.DESIGN.ENABLE_ADVANCED_MODE_EDITOR  = design["ENABLE_ADVANCED_MODE_EDITOR"].boolValue
        //URL
        let url = json["URL"]
        self.URL.PATH_GIFTCODE = url["PATH_GIFTCODE"].stringValue
        self.URL.LINK_FANAPGE = url["LINK_FANAPGE"].stringValue
        self.URL.LINK_SCHEME_FANPAGE = url["LINK_SCHEME_FANPAGE"].stringValue
        self.URL.FORM_FEEBACK = url["FORM_FEEBACK"].stringValue
        self.URL.LINK_GARAGEBAND = url["LINK_GARAGEBAND"].stringValue
        self.URL.LINK_API_CATEGORY =  url["LINK_API_CATEGORY"].stringValue
        self.URL.LINK_LIST_RINGTONE =  url["LINK_LIST_RINGTONE"].stringValue
        self.URL.LINK_CATEGORY_WALLPAPER =  url["LINK_CATEGORY_WALLPAPER"].stringValue
        self.URL.LINK_CATEGORY_LIVE_WALLPAPER =  url["LINK_CATEGORY_LIVE_WALLPAPER"].stringValue
        self.URL.LINK_SEARCH_RINGTONE =  url["LINK_SEARCH_RINGTONE"].stringValue
        
        //APP_NAVIGATION
        let nav = json["APP_NAVIGATION"]
        self.APP_NAVIGATION.IS_SHOW_ALWAYS = nav["IS_SHOW_ALWAYS"].boolValue
        self.APP_NAVIGATION.IMAGE_URL = nav["IMAGE_URL"].stringValue
        self.APP_NAVIGATION.URL = nav["URL"].stringValue
        self.APP_NAVIGATION.ENABLE = nav["ENABLE"].boolValue
        self.APP_NAVIGATION.TITLE = nav["TITLE"].stringValue
        self.APP_NAVIGATION.MESSAGE = nav["MESSAGE"].stringValue
        self.APP_NAVIGATION.BUTTON_NAME = nav["BUTTON_NAME"].stringValue
        self.APP_NAVIGATION.COLOR_TEXT = nav["COLOR_TEXT"].stringValue
        self.APP_NAVIGATION.COLOR_BACKGROUND = nav["COLOR_BACKGROUND"].stringValue
        self.APP_NAVIGATION.COLOR_BUTTON_TEXT = nav["COLOR_BUTTON_TEXT"].stringValue
        self.APP_NAVIGATION.COLOR_BUTTON_BACKGROUND = nav["COLOR_BUTTON_BACKGROUND"].stringValue
        
        // Artist
        let art = json["Artist"]
        var listArt: [Artist] = []
        for (_, json) : (String, JSON) in art{
            listArt.append(Artist(id: UUID(), name: json["name"].stringValue, subscribers: json["subscribers"].stringValue, thumbnails: json["thumbnails"].stringValue))
        }
        self.ART = listArt
        // genress
        let genress = json["Genres"]
        var listGenress: [Genres] = []
        for (_, json) : (String, JSON) in genress{
            listGenress.append(Genres(id: UUID(), name: json["name"].stringValue))
        }
        self.GENRES = listGenress
    }
    //Load old
    func loadOldVersion(path: String,_ completion: @escaping (()->Void)){
        self.OBSERVER_MANIFEST = Database.database().reference().child(path).observe(.value){snapshot in
            if !snapshot.exists(){
                debugPrint("MANIFEST URL NOT FOULD!")
                return
            }
            let json = JSON(snapshot.value as Any)
            self.pareManifestOld(json) {
                completion()
            }
        }
    }
    func pareManifestOld(_ json: JSON, completion: @escaping ()->Void){
        parseOther(json)
        completion()
    }
    
}

extension CONSTANT{
    static var EXPIRED_PREMIUM = "EXPIRED_PREMIUM"
    static var IS_AUTO_RENEWS = "IS_AUTO_RENEWS"
    static var COUNT_DOWNLOAD = "COUNT_DOWNLOAD"
    static var TIME_ADS_OPEN = "TIME_ADS_OPEN"
    static var COUNT_SHOW_RATE = "COUNT_SHOW_RATE"
}

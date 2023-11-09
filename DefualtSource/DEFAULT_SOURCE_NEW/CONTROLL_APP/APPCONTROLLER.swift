

import Foundation
import SwiftUI


class APPCONTROLLER: ObservableObject {
    static var shared = APPCONTROLLER()
    
    @Published var SHOW_OPEN_APPP = true
    @Published var SHOW_RECOMMAND = false
    @Published var showToast = false
    @Published var FIRST_OPEN = true
    
    @Published var MANIFEST_UPDATE = false
    
    @Published var SHOW_PREMIUM = false
    @Published var SHOW_RATE = false
    @Published var SHOW_INTRODUCTION = false
    @Published var SHOW_TUTORIAL = false
    @Published var SHOW_MORE_APP = false
    @Published var SHOW_MENU = false
    @Published var SHOW_LOADING = false
    @Published var STATUS_LOADING  = ""
    //
    @Published var ADS_READY = false
    @Published var SHOW_ADSOPEN = false
    var COUNT_INTERSTITIAL = 0
    @Published var INDEX_TABBAR = 0
    @Published var EXPAND = false
    //
    @Published var SHOW_MESSAGE_ON_SCREEN = false
    @Published var MESSAGE_ON_SCREEN = ""
    @Published var TIMER_MESSAGE_ON_SCREEN: Timer?
    //
    @Published var BAGE_VALUE = 0
    //
    @Published var SHOW_APP_NAVIGATION = false
    
    //AppStorage
    @AppStorage("firstOpen") var firstOpen = true
    @AppStorage("darkMode") var darkMode = false
   
}


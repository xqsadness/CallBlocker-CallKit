//
//  DefualtSourceApp.swift
//  DefualtSource
//
//  Created by CycTrung on 06/09/2023.
//

import SwiftUI
import Firebase
import GoogleMobileAds

@main
struct DefualtSourceApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var appController = APPCONTROLLER.shared
    
    var body: some Scene {
        WindowGroup {
            RootView().preferredColorScheme(appController.darkMode ? .dark : .light)
        }
    }
}

struct RootView: View {
    @StateObject var appController = APPCONTROLLER.shared
    @StateObject var localNotification = LocalNotification.shared
    @StateObject var authManagerViewModel = AuthManagerViewModel.shared
    @StateObject var user = User.shared
    @StateObject var coordinator = Coordinator.shared
    @StateObject var alerter: Alerter = Alerter.shared
    @AppStorage("FIRST_LOAD_APP") var FIRST_LOAD_APP = false
    
    var body: some View {
        VStack{
            NavigationStack(path: $coordinator.path) {
                Group{
                    if appController.SHOW_OPEN_APPP{
                        ZStack{
                            Image("AppIconSingle")
                                .resizable()
                                .frame(width: 80, height: 80, alignment: .center)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color("LauchScreen"))
                        .overlay(alignment: .bottom) {
                            //https://lottiefiles.com/9329-loading
                            LottieView(name: "loading_default", loopMode: .loop)
                                .frame(maxWidth: .infinity)
                                .frame(height: 200)
                        }
                    }
                    else{
    //                    if appController.firstOpen{
    //                        HomeOnBoarding()
    //                    }else{
                            ContentView()
    //                    }
                    }
                }
                .environmentObject(appController)
                .environmentObject(authManagerViewModel)
                .environmentObject(user)
                .environmentObject(coordinator)
                .environmentObject(alerter)
                .navigationBarHidden(true)
                .navigationDestination(for: Page.self) { page in
                    coordinator.build(page: page)
                }
                .sheet(item: $coordinator.sheet) { sheet in
                    coordinator.build(sheet: sheet)
                }
                .fullScreenCover(item: $coordinator.fullScreenCover) { fullScreencover in
                    coordinator.build(fullScreenCover: fullScreencover)
                }
                .onAppear(perform: {
                    if !appController.SHOW_OPEN_APPP{
                        return
                    }
                    CONSTANT.SHARED.load {
                        appController.SHOW_OPEN_APPP = true
                        self.openApp()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                            withAnimation {
                                appController.SHOW_OPEN_APPP = false
                            }
                        })
                    }
                })
                .alert(isPresented: $alerter.isShowingAlert) {
                    alerter.alert ?? Alert(title: Text(""))
                }
                //            .onChange(of: appController.INDEX_TABBAR, perform: { b in
                //                if User.isShowInterstitial() == false{
                //                    return
                //                }
                //                appController.COUNT_INTERSTITIAL += 1
                //                if appController.COUNT_INTERSTITIAL % CONSTANT.SHARED.ADS.INTERVAL_INTERSTITIAL == 0{
                //                    InterstitialAd.shared.show()
                //                }
                //            })
                .onReceive(NotificationCenter.default.publisher(for: UIApplication.didBecomeActiveNotification)) { (output) in
                    if User.isShowRate(){
                        MyAlert.showRate()
                    }
                    else{
                        if User.isShowAdsOpen(){
                            AdsOpenAd.shared.show()
                        }
                    }
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("PushMessage"))) { (output) in
            DispatchQueue.main.async {
                guard let str = output.userInfo?["data"] as? String else {return}
                
                appController.MESSAGE_ON_SCREEN = str
                withAnimation(.easeInOut(duration: 1)) {
                    appController.SHOW_MESSAGE_ON_SCREEN  = true
                }
                appController.TIMER_MESSAGE_ON_SCREEN?.invalidate()
                appController.TIMER_MESSAGE_ON_SCREEN = Timer.scheduledTimer(withTimeInterval: 3, repeats: false, block: { _ in
                    withAnimation(.easeInOut(duration: 1)){
                        appController.SHOW_MESSAGE_ON_SCREEN  = false
                    }
                })
            }
        }
        .overlay(alignment: .bottom, content: {
            appController.SHOW_MESSAGE_ON_SCREEN ?
            NotificationView()
            : nil
        })
    }
    
    func openApp(){
        User.shared.getUser()
        GADMobileAds.sharedInstance().start(completionHandler: {_ in
            GADMobileAds.sharedInstance().applicationMuted = true
            DispatchQueue.main.async {
                withAnimation(.easeInOut(duration: 5)){
                    APPCONTROLLER.shared.ADS_READY = true
                }
            }
        })
    }
}

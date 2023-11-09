//
//  ContentView.swift
//  DefualtSource
//
//  Created by CycTrung on 06/09/2023.
//

import SwiftUI
import StoreKit

struct ContentView: View {
    @StateObject var appController = APPCONTROLLER.shared
    
    var body: some View {
        VStack {
//            if User.shared.userUID != ""{
                HomeView()
//            }else{
//                LoginDefaultView()
//            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .appStoreOverlay(isPresented: $appController.SHOW_RECOMMAND) {
            SKOverlay.AppConfiguration(appIdentifier: CONSTANT.SHARED.ADS.APP_ID_RECOMMEND, position: .bottom)
        }
//        .onAppear{
//            if CONSTANT.SHARED.ADS.ENABLE_RECOMMEND{
//                DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
//                    withAnimation {
//                        appController.SHOW_RECOMMAND = true
//                    }
//                })
//            }
//            
//            VersionApp.shared.checkUpdateVersionApp { (status) in
//                if status{
//                    print("update version now")
//                    // show popup update version app
//                }else{
//                    print("latest version")
//                }
//            } onError: { (status) in
//                // Handle error
//                print(status)
//            }
//        }
    }
}



//
//  PremiumDefaultView.swift
//  DefualtSource
//
//  Created by darktech4 on 12/09/2023.
//

import SwiftUI

struct PremiumDefaultView: View {
    @EnvironmentObject var coordinator: Coordinator
    
    var body: some View {
        VStack{
            ZStack(alignment: .top) {
                ZStack {
                    Image("imgBanner")
                        .resizable()
                        .frame(maxWidth: .infinity)
                        .ignoresSafeArea()
                    
                    LinearGradient(colors: [.background,.clear], startPoint: .bottom, endPoint: .top)
                }
                
                Text("Musify Premium")
                    .font(Font.bold(size: 20))
                    .foregroundColor(Color.text)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .overlay(alignment : .trailing) {
                        Image(systemName: "xmark")
                            .imageScale(.large)
                            .foregroundColor(Color.text2)
                            .padding(.trailing)
                            .onTapGesture {
                                coordinator.dissmissFullscreenCover()
                            }
                    }
            }
            
            Text("Get 3 days free trial, download & import your music with premium")
                .font(Font.medium(size: 17))
                .foregroundColor(Color.text)
                .multilineTextAlignment(.center)

            ListChooseView()
            
            HStack(spacing: 30){
                Text("Term")
                    .foregroundColor(Color.text)
                    .font(Font.medium(size: 13))
                
                Text("Privacy")
                    .foregroundColor(Color.text)
                    .font(Font.medium(size: 13))
                
                Text("Restore")
                    .foregroundColor(Color.text)
                    .font(Font.medium(size: 13))
            }
            .padding(.bottom,5)
            
            Text("After 3 days free trial, payment will be charged to your iTunes automatically. Subscriptions will automatically renew unless you cancel it at least 24 hours before the end of the current period. You can manage your auto-renew subscriptions in your Apple ID Account settings.")
                .foregroundColor(Color.text)
                .font(Font.medium(size: 12))
                .multilineTextAlignment(.center)
                .padding(.bottom, 30)
            
            Spacer()
        }
        .background(Color.background)
    }
}

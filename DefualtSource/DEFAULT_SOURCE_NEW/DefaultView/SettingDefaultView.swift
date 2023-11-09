//
//  SettingDefaultView.swift
//  DefualtSource
//
//  Created by darktech4 on 08/09/2023.
//

import SwiftUI
import SafariServices

struct SettingDefaultView: View {
    @EnvironmentObject var coordinator: Coordinator
    @StateObject var appController = APPCONTROLLER.shared
    @State var isContact = false
    
    var body: some View {
        NavigationView {
            VStack{
                HStack {
                    Text("Setting")
                        .font(Font.bold(size: 20))
                        .foregroundColor(Color.text)
                    
                    Spacer()
                }
                .padding(.top)
                .padding(.horizontal)
                
                HStack{
                    VStack(spacing: 12){
                        Text("Try Premium for Free")
                            .foregroundColor(Color.text)
                            .font(.bold(size: 17))
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        Text("No Ads and more features")
                            .foregroundColor(Color.text)
                            .font(.regular(size: 13))
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                    
                    Spacer()
                    
                    Image("pre-icon")
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .padding(.horizontal)
                .frame(height: 80)
                .frame(maxWidth: .infinity)
                .background(.linearGradient(colors: [Color(hex: "#ED8770"), Color(hex: "#D9519D")], startPoint: .topLeading, endPoint: .bottomTrailing))
                .cornerRadius(10)
                .padding()
                .onTapGesture {
                    coordinator.presentFullScreen(.premiumDefaultView)
                }
                
                VStack {
                    if let url = URL(string: CONSTANT.SHARED.INFO_APP.APPSTORE_URL) {
                        ShareLink(item: url){
                            VStack{
                                HStack(spacing : 10){
                                    Image(systemName: "link")
                                        .imageScale(.large)
                                        .foregroundColor(Color("LauchScreen"))
                                        .frame(width: 40)
                                    
                                    Text("Share with Fiend")
                                        .foregroundColor(Color.text)
                                        .font(Font.regular(size: 17))
                                        .padding(.leading, 10)
                                    
                                    Spacer()
                                }
                                .frame(height: 56)
                                Divider()
                            }
                        }
                    }
                    
                    VStack{
                        HStack(spacing : 10){
                            Image(systemName: "moon")
                                .imageScale(.large)
                                .foregroundColor(Color("LauchScreen"))
                                .frame(width: 40)
                            
                            Toggle("Dark mode", isOn: $appController.darkMode)
                                .foregroundColor(Color.text)
                                .padding(.leading, 10)
                            
                            Spacer()
                        }
                        .frame(height: 56)
                        Divider()
                    }
                    
                    Button {
                        if let url = URL(string: CONSTANT.SHARED.INFO_APP.APPSTORE_URL) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        VStack{
                            HStack(spacing : 10){
                                Image(systemName: "star")
                                    .imageScale(.large)
                                    .foregroundColor(Color("LauchScreen"))
                                    .frame(width: 40)
                                
                                Text("Rate Us")
                                    .foregroundColor(Color.text)
                                    .font(Font.regular(size: 17))
                                    .padding(.leading, 10)
                                
                                Spacer()
                            }
                            .frame(height: 56)
                            Divider()
                        }
                    }
                    
                    Button {
                        isContact = true
                    } label: {
                        VStack{
                            HStack(spacing : 10){
                                Image(systemName: "person.2")
                                    .imageScale(.large)
                                    .foregroundColor(Color("LauchScreen"))
                                    .frame(width: 40)
                                
                                Text("Feedback")
                                    .foregroundColor(Color.text)
                                    .font(Font.regular(size: 17))
                                    .padding(.leading, 10)
                                
                                Spacer()
                            }
                            .frame(height: 56)
                            Divider()
                        }
                    }
                    
                    Button {
                        if let url = URL(string: CONSTANT.SHARED.INFO_APP.PRIVACY) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        VStack{
                            HStack(spacing : 10){
                                Image(systemName: "doc.text")
                                    .imageScale(.large)
                                    .foregroundColor(Color("LauchScreen"))
                                    .frame(width: 40)
                                
                                Text("Privacy Policy")
                                    .foregroundColor(Color.text)
                                    .font(Font.regular(size: 17))
                                    .padding(.leading, 10)
                                
                                Spacer()
                            }
                            .frame(height: 56)
                            Divider()
                        }
                    }
                    
                    Button {
                        if let url = URL(string: CONSTANT.SHARED.INFO_APP.TERM) {
                            UIApplication.shared.open(url)
                        }
                    } label: {
                        VStack{
                            HStack(spacing : 10){
                                Image(systemName: "lock.doc")
                                    .imageScale(.large)
                                    .foregroundColor(Color("LauchScreen"))
                                    .frame(width: 40)
                                
                                Text("Term of Service")
                                    .foregroundColor(Color.text)
                                    .font(Font.regular(size: 17))
                                    .padding(.leading, 10)
                                
                                Spacer()
                            }
                            .frame(height: 56)
                        }
                    }
                }
                .padding(.horizontal)
                .padding(.vertical, 2)
                .frame(maxWidth: .infinity)
                .cornerRadius(10)
                .padding()
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
//            .background(Color.background3)
            .fullScreenCover(isPresented: $isContact) {
                SFSafariViewWrapper(url : CONSTANT.SHARED.URL.FORM_FEEBACK)
            }
        }
    }
}

struct SFSafariViewWrapper: UIViewControllerRepresentable {
    let url: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        if let u = URL(string: url){
            return SFSafariViewController(url: u)
        }
        else{
            return SFSafariViewController(url: URL(string: "https://www.google.com/")!)
        }
    }
    
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<SFSafariViewWrapper>) {
        return
    }
}

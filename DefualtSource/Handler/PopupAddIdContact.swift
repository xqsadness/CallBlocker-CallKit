//
//  PopupAddIdContact.swift
//  DefualtSource
//
//  Created by darktech4 on 09/11/2023.
//

import SwiftUI
import CallKit

struct PopupAddIdContact: View {
    @StateObject var contactViewModel = ContactViewModel.shared
    @State private var isDelete = false
    @State private var name = ""
    @State private var phone = ""
    @Binding var showingPopup: Bool
    
    var body: some View {
        VStack{
            Text("\(isDelete ? "Delete" : "Add") name Id Contact (TAP TO SWITCHED)")
                .hAlign(.center)
                .lineLimit(2)
                .multilineTextAlignment(.center)
                .foregroundColor(.text)
                .font(.regular(size: 19))
                .padding(.bottom, 20)
                .onTapGesture {
                    phone = ""
                    withAnimation {
                        isDelete.toggle()
                    }
                }
            
            if !isDelete{
                TextField("Enter name Identification", text: $name)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.bottom,15)
            }
            TextField("Enter phone number", text: $phone)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding(.bottom,25)
            
            Button{
                if !isDelete{
                    if name.isEmpty{
                        LocalNotification.shared.message("Please ennter name Identification", .warning)
                    }
                    //                else if !phone.hasPrefix("84") {
                    //                    LocalNotification.shared.message("Please ennter country dial code followed by phone number (84)", .warning)
                    //                }
                    else{
                        contactViewModel.addIdentification(phone: phone, name: name)
                    }
                }else{
                    contactViewModel.deleteIdentification(phone: phone, name: name)
                }
                
                withAnimation {
                    showingPopup.toggle()
                }
            }label: {
                Text(isDelete ? "Delete" : "Add")
                    .foregroundColor(.white)
                    .font(.regular(size: 17))
            }
            .customButtonStyle(backgroundColor: .blue, textColor: .white, cornerRadius: 7)
        }
        .padding(.horizontal)
        .hAlign(.center)
        .frame(height: isDelete ? 185 : 253)
        .background(Color.text2)
        .cornerRadius(13)
        .padding(.horizontal)
    }
}

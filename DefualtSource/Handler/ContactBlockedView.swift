//
//  ContactBlockedView.swift
//  DefualtSource
//
//  Created by darktech4 on 09/11/2023.
//

import SwiftUI
import CallKit
import RealmSwift

struct ContactBlockedView: View {
    @ObservedResults(Contact.self) var blockeds
    @StateObject var contactViewModel = ContactViewModel.shared
    @Environment(\.dismiss) var dismiss
    @State private var showingAlert = false
    @State private var phone = ""
    
    var body: some View {
        VStack{
            HStack{
                Image(systemName: "arrowshape.backward")
                    .imageScale(.large)
                    .foregroundColor(.blue)
                    .padding(.horizontal)
                    .onTapGesture {
                        dismiss()
                    }
                Spacer()
                Text("Contact Blocked")
                    .font(.regular(size: 19))
                    .foregroundColor(.text)
                Spacer()
                Image(systemName: "plus.app")
                    .imageScale(.large)
                    .foregroundColor(.blue)
                    .padding(.horizontal)
                    .onTapGesture {
                        phone = ""
                        showingAlert.toggle()
                    }
            }
            .alert("Add phone blocked", isPresented: $showingAlert) {
                TextField("Enter phone number blocked.", text: $phone)
                    .keyboardType(.numberPad)
                
                Button("OK", action: {
                    if !phone.isEmpty{
                        contactViewModel.addPhoneNumberBlocked(phoneNumber: phone, name: "")
                    }else{
                        LocalNotification.shared.message("Please Enter Phone", .warning)
                    }
                })
            } message: {
                Text("Enter phone number blocked")
            }
            Spacer()
            if blockeds.isEmpty{
                Text("No contact blocked !")
                    .hAlign(.center)
                    .foregroundColor(.text)
                    .font(.regular(size: 18))
                    .vAlign(.center)
            }else{
                List{
                    ForEach(blockeds, id: \.id) { contact in
                        Text("\(contact.name):\(contact.phoneNumber)")
                            .hAlign(.leading)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                contactViewModel.deletePhoneNumberBlocked(idContactRealm: contact.id, phoneNumber: contact.phoneNumber)
                            }
                    }
                }
            }
        }
        .navigationBarBackButtonHidden(true)
        //        .navigationTitle("Blocked Contacts")
    }
}

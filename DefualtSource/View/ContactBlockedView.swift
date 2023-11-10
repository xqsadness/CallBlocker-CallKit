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
    @State private var showAlertDeleteAll = false
    
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
                
                Text("Contact Blocked (\(blockeds.count))")
                    .font(.regular(size: 19))
                    .foregroundColor(.text)
                Spacer()
                
                Image(systemName: "plus.app")
                    .imageScale(.large)
                    .foregroundColor(.blue)
                    .padding(.trailing,5)
                    .onTapGesture {
                        contactViewModel.phoneNumberAdd = ""
                        showingAlert.toggle()
                    }
                
                Image(systemName: "trash.slash")
                    .imageScale(.large)
                    .foregroundColor(.blue)
                    .padding(.trailing)
                    .onTapGesture {
                        showAlertDeleteAll.toggle()
                    }
            }
            .alert("Add phone blocked", isPresented: $showingAlert) {
                TextField("Enter phone number blocked.", text: $contactViewModel.phoneNumberAdd)
                    .keyboardType(.numberPad)
                
                Button("OK", action: {
                    if !contactViewModel.phoneNumberAdd.isEmpty{
                        contactViewModel.addPhoneNumberBlocked(phoneNumber: contactViewModel.phoneNumberAdd, name: "")
                    }else{
                        LocalNotification.shared.message("Please Enter Phone", . warning)
                    }
                })
            } message: {
                Text("Your Country Code Is: +\(CountryCodeViewModel.shared.selectedCountryCode)")
            }
            .alert(isPresented: $showAlertDeleteAll) {
                Alert(
                    title: Text("Delete All Contact Blocked"),
                    message: Text("Are you sure want to delete all contact blocked."),
                    primaryButton: .default(
                        Text("Cancel"),
                        action: {}
                    ),
                    secondaryButton: .destructive(
                        Text("Delete"),
                        action: {withAnimation {
                            contactViewModel.deleteAllPhoneNumberBlocked()
                        }}
                    )
                )
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
                        Text("\(contact.name) : +\(contact.phoneNumber)")
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


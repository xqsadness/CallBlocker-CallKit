//
//  ItemAllContactView.swift
//  DefualtSource
//
//  Created by darktech4 on 09/11/2023.
//

import SwiftUI
import CallKit

struct ItemAllContactView: View {
    @Binding var contact: (String, String)
    @StateObject var contactViewModel = ContactViewModel.shared
    
    var body: some View {
        Menu("\(contact.0): \(contact.1)") {
            Button("Block", action: {
                contactViewModel.addPhoneNumberBlocked(phoneNumber: contact.1, name: contact.0)
            })
            
            Button("Cancel", action: {})
        }
    }
}


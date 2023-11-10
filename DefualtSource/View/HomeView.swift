//
//  HomeView.swift
//  DefualtSource
//
//  Created by darktech4 on 11/09/2023.
//

import SwiftUI
import CallKit
import Contacts
import RealmSwift

struct HomeView: View {
    @State private var allContacts: [(String, String)] = []
    @State private var showingPopup = false
    
    var body: some View {
        NavigationView {
            VStack{
                HStack{
                    Text("All Contacts")
                        .foregroundColor(.text)
                        .font(.system(.largeTitle))
                        .bold()
                    Spacer()
                    
                    CountryCodePicker()
                }
                .padding(.horizontal)
                .padding(.bottom,5)
                
                HStack{
                    NavigationLink{
                        ContactBlockedView()
                    }label: {
                        Text("List Contact Blocked")
                            .foregroundColor(.blue)
                            .font(.regular(size: 17))
                    }
                    
                    Spacer()
                    
                    Text("Manager Id Contact")
                        .foregroundColor(.blue)
                        .font(.regular(size: 17))
                        .onTapGesture {
                            withAnimation {
                                showingPopup.toggle()
                            }
                        }
                }
                .padding(.horizontal)
                
                List(allContacts, id: \.1) { contact in
                    ItemAllContactView(contact: .constant(contact))
                }
                .onAppear(perform: loadContacts)
                .refreshable {
                    loadContacts()
                }
                
                Text("Please enable the application in settings to be able to use it (Settings → Phone → Call blocking & Identification)")
                    .font(.regular(size: 14.4))
                    .foregroundColor(.text).opacity(0.64)
                    .hAlign(.leading)
                    .multilineTextAlignment(.leading)
                    .lineLimit(3)
                    .padding(.horizontal, 5)

            }
            .popup(isPresented: $showingPopup){
                PopupAddIdContact(showingPopup: $showingPopup)
            }
            .onAppear {
                if let userDefaults = UserDefaults(suiteName: "group.com.blockedContact") {
                    userDefaults.set("__.__" as AnyObject, forKey: "ios")
                }
            }
            .onDisappear{
                if let userDefaults = UserDefaults(suiteName: "group.com.blockedContact") {
                    userDefaults.removeObject(forKey: "ios")
                }
            }
        }
    }
    
    // Function to request access to the user's contacts and load them
    func loadContacts() {
        // Request necessary permissions
        requestPermissions()
        
        // Check the authorization status for contacts
        let status = CNContactStore.authorizationStatus(for: .contacts)
        
        if status == .denied || status == .restricted {
            // Handle the case when contact access is denied or restricted
            // You might want to prompt the user to grant access or provide instructions
            return
        }
        
        // Create a contact store instance
        let contactStore = CNContactStore()
        contactStore.requestAccess(for: .contacts) { (granted, error) in
            if granted {
                // Access to contacts is granted, fetch and store contacts
                let contacts = self.fetchContacts(contactStore)
                DispatchQueue.main.async {
                    self.allContacts = contacts
                }
            } else {
                // Access to contacts is denied, prompt the user to grant access
                self.promptUserForContactAccess()
            }
        }
    }
    
    // Function to fetch contacts from the user's address book
    func fetchContacts(_ contactStore: CNContactStore) -> [(String, String)] {
        var contacts: [(String, String)] = []
        let keysToFetch = [CNContactPhoneNumbersKey, CNContactGivenNameKey] as [CNKeyDescriptor]
        
        let containerIdentifier = contactStore.defaultContainerIdentifier
        let predicate = CNContact.predicateForContactsInContainer(withIdentifier: containerIdentifier())
        
        do {
            let contactTemp = try contactStore.unifiedContacts(matching: predicate, keysToFetch: keysToFetch)
            
            for contact in contactTemp {
                for phoneNumber in contact.phoneNumbers {
                    let number = phoneNumber.value.stringValue.removeFormat()
                    let name = contact.givenName
                    if !number.isEmpty {
                        contacts.append((name, number))
                    }
                }
            }
        } catch {
            print(error)
        }
        
        return contacts.sorted { $0.0 < $1.0 }
    }
    
    // Function to prompt the user to grant access to contacts
    func promptUserForContactAccess() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
        }
    }
}

extension String {
    func removeFormat() -> String {
        var mobileNumber: String = self
        mobileNumber = mobileNumber.trimmingCharacters(in: .whitespacesAndNewlines)
        mobileNumber = mobileNumber.replacingOccurrences(of: "+", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: " ", with: "")
        mobileNumber = mobileNumber.replacingOccurrences(of: "-", with: "")
        return mobileNumber
    }
}

func requestPermissions() {
    // Xác định quyền truy cập danh bạ
    let contactStore = CNContactStore()
    contactStore.requestAccess(for: .contacts) { granted, error in
        if granted {
            // Quyền truy cập danh bạ đã được cấp
            // Tiếp theo, bạn có thể yêu cầu quyền truy cập CallKit
        } else {
            //handle error
        }
    }
}

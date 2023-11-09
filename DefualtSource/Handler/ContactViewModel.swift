//
//  ContactViewModel.swift
//  DefualtSource
//
//  Created by darktech4 on 08/11/2023.
//

import Foundation
import RealmSwift
import SwiftUI
import CallKit

class Contact: Object, ObjectKeyIdentifiable{
    @Persisted(primaryKey: true) var id: String
    @Persisted var phoneNumber: String
    @Persisted var name: String
    
    convenience init(id: String,phoneNumber: String, name: String) {
        self.init()
        self.id = id
        self.phoneNumber = phoneNumber
        self.name = name
    }
}

class ContactViewModel: ObservableObject {
    static var shared = ContactViewModel()
    
    //props
    @Published var isDelete: Bool = false
    
    private var suiteName = "group.com.blockedContact"
    private var identifierExtension = "com.default.DefualtSource.CallDirectoryHandler"
    
    // init realm
    private let realm = try! Realm()
    
    //add object contact in realm
    private func addContactBlockedRealm(id: String,phoneNumber: String, name: String) {
        if realm.objects(Contact.self).filter("phoneNumber = %@", phoneNumber).first == nil {
            let historyModel = Contact()
            historyModel.id = id
            historyModel.name = name
            historyModel.phoneNumber = phoneNumber
            try! realm.write {
                realm.add(historyModel)
            }
        }
    }
    
    //delete object contact with id in realm
    private func deleteContactBlockedRealm(id: String) {
        if let historyModel = realm.object(ofType: Contact.self, forPrimaryKey: id) {
            try! realm.write {
                withAnimation {
                    realm.delete(historyModel)
                }
            }
        }
    }
    
    // Add a phone number to UserDefaults for share with app group call Directory extension
    func addPhoneNumberBlocked(phoneNumber: String, name: String){
        // Store the status and the phone number to be added block list in UserDefaults
        DispatchQueue.main.async {
            if let userDefaults = UserDefaults(suiteName: self.suiteName) {
                userDefaults.set(HandleTypeContact.addBlocked.rawValue as AnyObject, forKey: "handleTypeContact")
                userDefaults.set("\(phoneNumber)" as AnyObject, forKey: "phoneNumberAdd")
                userDefaults.synchronize()
            }
        }
        
        // Call a function to reload the Call Directory extension to update the data
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: self.identifierExtension){ error in
            if let error = error{
                LocalNotification.shared.message("Please enable the application in settings to be able to use it (Settings → Phone → Call blocking & Identification)", .error)
                print("Error in func addPhoneNumberBlocked: \(error.localizedDescription)")
            }else{
                DispatchQueue.main.async {
                    // Call a function to add a phone number to the block list realm
                    self.addContactBlockedRealm(id: UUID().uuidString, phoneNumber: phoneNumber, name: name)
                    LocalNotification.shared.message("Block \(phoneNumber) success", .success)
                }
            }
        }
    }
    
    // Add a phone number delete to UserDefaults for share with app group call Directory extension
    func deletePhoneNumberBlocked(idContactRealm: String, phoneNumber: String){
        // Store the status and the phone number to be removed in UserDefaults
        DispatchQueue.main.async {
            if let userDefaults = UserDefaults(suiteName: self.suiteName) {
                userDefaults.set(HandleTypeContact.deleteBlocked.rawValue as AnyObject, forKey: "handleTypeContact")
                userDefaults.set("\(phoneNumber)" as AnyObject, forKey: "phoneNumberDelete")
                userDefaults.synchronize()
            }
        }
        
        // Call a function to reload the Call Directory extension to update the data
        CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: self.identifierExtension){ error in
            if let error = error{
                LocalNotification.shared.message("Please enable the application in settings to be able to use it (Settings → Phone → Call blocking & Identification)", .error)
                print("Error in func deletePhoneNumberBlocked: \(error.localizedDescription)")
            }else{
                DispatchQueue.main.async {
                    withAnimation {
                        // Call a function to remove a blocked phone number within the app (realm)
                        self.deleteContactBlockedRealm(id: idContactRealm)
                    }
                    LocalNotification.shared.message("Un Block \(phoneNumber) success", .success)
                }
            }
        }
    }
    
    // Add a name Identification to UserDefaults for share with app group call Directory extension
    func addIdentification(phone: String, name: String){
        DispatchQueue.main.async {
            if let userDefaults = UserDefaults(suiteName: self.suiteName) {
                userDefaults.set(HandleTypeContact.addIdentification.rawValue as AnyObject, forKey: "handleTypeContact")
                userDefaults.set("\(phone)" as AnyObject, forKey: "phoneNumberAdd")
                userDefaults.set(name as AnyObject, forKey: "nameID")
                userDefaults.synchronize()
            }
            
            // Call a function to reload the Call Directory extension to update the data
            CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: self.identifierExtension){ error in
                if let error = error{
                    LocalNotification.shared.message("Please enable the application in settings to be able to use it (Settings → Phone → Call blocking & Identification)", .error)
                    print("Error in func addIdentification: \(error.localizedDescription)")
                }else{
                    LocalNotification.shared.message("Set name for \(phone) is \(name) success", .success)
                }
            }
        }
    }
    
    // Add a name Identification delete to UserDefaults for share with app group call Directory extension
    func deleteIdentification(phone: String, name: String){
        DispatchQueue.main.async {
            if let userDefaults = UserDefaults(suiteName: self.suiteName) {
                userDefaults.set("\(phone)" as AnyObject, forKey: "phoneNumberAdd")
                userDefaults.set(HandleTypeContact.deleteIdentification.rawValue as AnyObject, forKey: "handleTypeContact")
                userDefaults.synchronize()
            }
            
            // Call a function to reload the Call Directory extension to update the data
            CXCallDirectoryManager.sharedInstance.reloadExtension(withIdentifier: self.identifierExtension){ error in
                if let error = error{
                    LocalNotification.shared.message("Please enable the application in settings to be able to use it (Settings → Phone → Call blocking & Identification)", .error)
                    print("Error in func deleteIdentification: \(error.localizedDescription)")
                }else{
                    LocalNotification.shared.message("Delete name \(name) success", .success)
                }
            }
        }
    }
    
}

enum HandleTypeContact: String{
    case deleteBlocked = "deleteBlocked"
    case addBlocked = "addBlocked"
    case deleteIdentification = "deleteIdentification"
    case addIdentification = "addIdentification"
}

//
//  CallDirectoryHandler.swift
//  CallDirectoryHandler
//
//  Created by darktech4 on 08/11/2023.
//

import Foundation
import CallKit

class CallDirectoryHandler: CXCallDirectoryProvider {
    
    override func beginRequest(with context: CXCallDirectoryExtensionContext) {
        context.delegate = self
        
        //  Check the status and the phone number to be added or removed from UserDefaults
        if let userDefaults = UserDefaults(suiteName: "group.com.blockedContact") {
            let handleTypeContact = userDefaults.string(forKey: "handleTypeContact")
            
            let nameID = userDefaults.string(forKey: "nameID")
            let phoneNumberAdd = userDefaults.string(forKey: "phoneNumberAdd")
            let phoneNumberDelete = userDefaults.string(forKey: "phoneNumberDelete")
            
            // Add or remove phone numbers from the block list and Identification based on the HandleTypeContact enum
            switch handleTypeContact {
            case HandleTypeContact.addBlocked.rawValue:
                // Handling when handleTypeContact is "addBlocked"
                if let phInt = Int64(phoneNumberAdd ?? "") {
                    context.addBlockingEntry(withNextSequentialPhoneNumber: phInt)
                }
            case HandleTypeContact.deleteBlocked.rawValue:
                // Handling when handleTypeContact is "deleteBlocked"
                if let phInt = Int64(phoneNumberDelete ?? "") {
                    context.removeBlockingEntry(withPhoneNumber: phInt)
                }
            case HandleTypeContact.addIdentification.rawValue:
                // Handling when handleTypeContact is "addIdentification"
                if let phInt = Int64(phoneNumberAdd ?? "") {
                    context.addIdentificationEntry(withNextSequentialPhoneNumber: phInt, label: nameID ?? "nil")
                }
            case HandleTypeContact.deleteIdentification.rawValue:
                // Handling when handleTypeContact is "deleteIdentification"
                if let phInt = Int64(phoneNumberAdd ?? "") {
                    context.removeIdentificationEntry(withPhoneNumber: phInt)
                }
            case HandleTypeContact.deleteAllBlocked.rawValue:
                // Handling when handleTypeContact is "deleteAllBlocked"
                context.removeAllBlockingEntries()
            case HandleTypeContact.deleteAllIdentification.rawValue:
                // Handling when handleTypeContact is "deleteAllIdentification"
                context.removeAllIdentificationEntries()
            default:
                // Handling the default case if handleTypeContact doesn't match any of the case values
                print("error handleTypeContact")
            }
        }
        
        // Complete the request
        context.completeRequest()
    }
    
    //MARK: - Available functions example when create Call Directory Extension, if not used it can be deleted
    private func addAllBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve all phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        //
        // Numbers must be provided in numerically ascending order.
        let allPhoneNumbers: [CXCallDirectoryPhoneNumber] = [ 1_408_555_5555, 1_800_555_5555 ]
        for phoneNumber in allPhoneNumbers {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
    }
    
    private func addOrRemoveIncrementalBlockingPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve any changes to the set of phone numbers to block from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        let phoneNumbersToAdd: [CXCallDirectoryPhoneNumber] = [ 1_408_555_1234 ]
        for phoneNumber in phoneNumbersToAdd {
            context.addBlockingEntry(withNextSequentialPhoneNumber: phoneNumber)
        }
        
        let phoneNumbersToRemove: [CXCallDirectoryPhoneNumber] = [ 1_800_555_5555 ]
        for phoneNumber in phoneNumbersToRemove {
            context.removeBlockingEntry(withPhoneNumber: phoneNumber)
        }
        
        // Record the most-recently loaded set of blocking entries in data store for the next incremental load...
    }
    
    private func addAllIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve phone numbers to identify and their identification labels from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        //
        // Numbers must be provided in numerically ascending order.
        let allPhoneNumbers: [CXCallDirectoryPhoneNumber] = [ 1_877_555_5555, 1_888_555_5555 ]
        let labels = [ "Telemarketer", "Local business" ]
        
        for (phoneNumber, label) in zip(allPhoneNumbers, labels) {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
        }
    }
    
    private func addOrRemoveIncrementalIdentificationPhoneNumbers(to context: CXCallDirectoryExtensionContext) {
        // Retrieve any changes to the set of phone numbers to identify (and their identification labels) from data store. For optimal performance and memory usage when there are many phone numbers,
        // consider only loading a subset of numbers at a given time and using autorelease pool(s) to release objects allocated during each batch of numbers which are loaded.
        let phoneNumbersToAdd: [CXCallDirectoryPhoneNumber] = [ 1_408_555_5678 ]
        let labelsToAdd = [ "New local business" ]
        
        for (phoneNumber, label) in zip(phoneNumbersToAdd, labelsToAdd) {
            context.addIdentificationEntry(withNextSequentialPhoneNumber: phoneNumber, label: label)
        }
        
        let phoneNumbersToRemove: [CXCallDirectoryPhoneNumber] = [ 1_888_555_5555 ]
        
        for phoneNumber in phoneNumbersToRemove {
            context.removeIdentificationEntry(withPhoneNumber: phoneNumber)
        }
        
        // Record the most-recently loaded set of identification entries in data store for the next incremental load...
    }
    
}

extension CallDirectoryHandler: CXCallDirectoryExtensionContextDelegate {
    func requestFailed(for extensionContext: CXCallDirectoryExtensionContext, withError error: Error) {
        // An error occurred while adding blocking or identification entries, check the NSError for details.
        // For Call Directory error codes, see the CXErrorCodeCallDirectoryManagerError enum in <CallKit/CXError.h>.
        //
        // This may be used to store the error details in a location accessible by the extension's containing app, so that the
        // app may be notified about errors which occurred while loading data even if the request to load data was initiated by
        // the user in Settings instead of via the app itself.
    }
}

extension String {
    func replaceLeadingZeroWith84() -> String {
        var modifiedString = self
        
        if self.count >= 1 && self.first == "0" {
            modifiedString.removeFirst()
            modifiedString = "84" + modifiedString
        }
        
        return modifiedString
    }
}

enum HandleTypeContact: String{
    case deleteBlocked = "deleteBlocked"
    case addBlocked = "addBlocked"
    case deleteIdentification = "deleteIdentification"
    case addIdentification = "addIdentification"
    case deleteAllBlocked = "deleteAllBlocked"
    case deleteAllIdentification = "deleteAllIdentification"
}

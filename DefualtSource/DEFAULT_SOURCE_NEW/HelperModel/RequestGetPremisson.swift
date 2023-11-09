//
//  RequestGetPremisson.swift
//  DefualtSource
//
//  Created by darktech4 on 13/10/2023.
//

import SwiftUI
import Photos

@MainActor
class RequestGetPermission {
    static let shared = RequestGetPermission()
    
    // Mark: Requests camera permission.
    func getPremissonCamera(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // Mark: Requests permission to access the photo library.
    func requestPhotoLibraryPermission(completion: @escaping (Bool) -> Void) {
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                completion(true)
            } else {
                completion(false)
            }
        }
    }
    
    // Mark: Requests location permission.
    func requestLocationPermission(completion: @escaping (Bool) -> Void) {
        let locationManager = CLLocationManager()
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            completion(true)
        } else {
            completion(false)
        }
    }
    
    // Mark: Opens the settings app to allow the user to change permissions for this app.
    func gotoSetting() -> Bool {
        guard let urlSettingApp = URL(string: UIApplication.openSettingsURLString) else { return false }
        UIApplication.shared.open(urlSettingApp, options: [:], completionHandler: nil)
        return true
    }
}

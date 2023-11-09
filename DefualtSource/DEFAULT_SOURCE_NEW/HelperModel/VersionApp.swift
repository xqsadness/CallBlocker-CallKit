//
//  Version.swift
//  DefualtSource
//
//  Created by darktech4 on 08/09/2023.
//

import Foundation

class VersionApp {
    static var shared = VersionApp()
    
    func checkUpdateVersionApp(onSuccess: @escaping (Bool) -> Void, onError: @escaping (Bool) -> Void) {
        guard let info = Bundle.main.infoDictionary,
              let currentVersion = info["CFBundleShortVersionString"] as? String,
              let appStoreURL = URL(string: "https://apps.apple.com/vn/app/genshin-impact-v4-0-fontaine/id1517783697") else {
            return onError(true)
        }
        
        let task = URLSession.shared.dataTask(with: appStoreURL) { data, response, error in
            if let error = error {
                print("Error load data from App Store: \(error.localizedDescription)")
                return onError(true)
            }
            
            if let data = data {
                do {
                    guard let json = try JSONSerialization.jsonObject(with: data, options: [.allowFragments]) as? [String: Any],
                          let results = json["results"] as? [Any],
                          let firstResult = results.first as? [String: Any],
                          let appStoreVersion = firstResult["version"] as? String else {
                        return onError(true)
                    }
                    
                    print("Version in App Store:", appStoreVersion, "Version now", currentVersion)
                    let versionCompare = currentVersion.compare(appStoreVersion, options: .numeric)
                    if versionCompare == .orderedSame {
                        onSuccess(false)
                    } else if versionCompare == .orderedAscending {
                        onSuccess(true)
                    }
                } catch {
                    onError(true)
                }
            }
        }
        task.resume()
    }
}

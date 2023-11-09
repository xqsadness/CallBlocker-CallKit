

import Foundation
import SwiftUI

extension FileManager {
    static func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    static func change(fileName: String, destination: URL = FileManager.getDocumentsDirectory()) -> String{
        let documentsDirectory = destination
        var trimmedSoundFileURL = documentsDirectory.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: trimmedSoundFileURL.path) {
            let filename = trimmedSoundFileURL.lastPathComponent
            var newFileName : String!
            var counter = 0
            var toPath = trimmedSoundFileURL.path
            while FileManager.default.fileExists(atPath: toPath) {
                counter += 1
                let fileExt  = trimmedSoundFileURL.pathExtension
                var fileNameWithoSuffix : String!
                if filename.hasSuffix(fileExt) {
                    fileNameWithoSuffix = String(filename.prefix(filename.count - (fileExt.count+1)))
                }
                if fileExt == "" {
                    newFileName =  "\(filename) (\(counter))"
                } else {
                    newFileName =  "\(fileNameWithoSuffix!) (\(counter)).\(fileExt)"
                }
                let newURL = URL(fileURLWithPath:trimmedSoundFileURL.path).deletingLastPathComponent().appendingPathComponent(newFileName).path
                toPath = newURL
            }
            trimmedSoundFileURL = URL(fileURLWithPath: toPath)
            return newFileName
        }
        return fileName
    }
    
    
    static func saveImage(image: UIImage, folder: String = "FolderImages", name: String, completion: ((URL)->Void)? = nil) {
        let documentsDirectory = FileManager.getDocumentsDirectory()
        let folderURL = documentsDirectory.appendingPathComponent(folder)
        guard let data = image.jpegData(compressionQuality: 0.25) else { return }
        //Check folder or created
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        //Checks if file exists, removes it if so.
        let fileURL = folderURL.appendingPathComponent(name+".jpg")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
            completion?(fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    static func saveImage(id: String, image: UIImage) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileName = id + ".jpg"
        let folderURL = documentsDirectory.appendingPathComponent("FolderImages")//.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        //Check folder or created
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        //Checks if file exists, removes it if so.
        let fileURL = folderURL.appendingPathComponent(fileName)
        if FileManager.default.fileExists(atPath: fileURL.path) {
            //            do {
            //                try FileManager.default.removeItem(atPath: fileURL.path)
            //                print("Removed old image")
            //            } catch let removeError {
            //                print("couldn't remove file at path", removeError)
            //            }
            return
        }
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    static func saveImage(image: UIImage, relativeURL: String = "", name: String) {
        let documentsDirectory = FileManager.getDocumentsDirectory()
        let folderURL = documentsDirectory.appendingPathComponent(relativeURL)
        guard let data = image.jpegData(compressionQuality: 0.25) else { return }
        //Check folder or created
        if !FileManager.default.fileExists(atPath: folderURL.path) {
            do {
                try FileManager.default.createDirectory(atPath: folderURL.path, withIntermediateDirectories: true, attributes: nil)
            } catch {
                print(error.localizedDescription)
            }
        }
        //Checks if file exists, removes it if so.
        let fileURL = folderURL.appendingPathComponent(name+".jpg")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
        do {
            try data.write(to: fileURL)
            
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    static func removeImage(folder: String = "FolderImages", name: String) {
        let documentsDirectory = FileManager.getDocumentsDirectory()
        let folderURL = documentsDirectory.appendingPathComponent(folder)
        let fileURL = folderURL.appendingPathComponent(name+".jpg")
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
                print("Removed old image")
            } catch let removeError {
                print("couldn't remove file at path", removeError)
            }
        }
    }
    
    static func loadImageFromDiskWith(id: String, folder: String = "FolderImages") -> UIImage? {
        let document = FileManager.getDocumentsDirectory()
        let imageUrl = document.appendingPathComponent(folder).appendingPathComponent(id + ".jpg")
        if FileManager.default.fileExists(atPath: imageUrl.path){
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
        }else{
            return nil
        }
    }
}

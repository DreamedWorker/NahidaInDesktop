//
//  ImageScreenModel.swift
//  GIWidget
//
//  Created by 鸳汐 on 2024/7/27.
//

import Foundation

class ImageScreenModel : ObservableObject {
    let imageDir = rootFileURL!.appending(component: "images").getPathWithoutEscape()
    @Published var imgs: [URL] = []
    
    func initDir() {
        if !checkForExist(filePath: imageDir) {
            try! FileManager.default.createDirectory(atPath: imageDir, withIntermediateDirectories: true)
        }
    }
    
    func getPictures() {
        imgs.removeAll()
        let temp = try! FileManager.default.contentsOfDirectory(at: URL(string: imageDir)!, includingPropertiesForKeys: nil)
        temp.forEach { single in
            imgs.append(single)
        }
    }
    
    func cp2storage(requiredPath: String) -> EventCallback {
        let fileName = requiredPath.split(separator: "/").last!
        do {
            try FileManager.default.copyItem(atPath: requiredPath, toPath: (imageDir + "/\(fileName)"))
            getPictures()
            return EventCallback(eventOK: true)
        } catch {
            return EventCallback(eventOK: false, message: error.localizedDescription)
        }
    }
    
    func remove2trash(objectURL: URL) -> EventCallback {
        do {
            try FileManager.default.trashItem(at: objectURL, resultingItemURL: nil)
            getPictures()
            return EventCallback(eventOK: true)
        } catch {
            return EventCallback(eventOK: false, message: error.localizedDescription)
        }
    }
}

//
//  FileHandler.swift
//  GIWidget
//
//  Created by 鸳汐 on 2024/7/23.
//

import Foundation

let rootFileURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.org.giwidget.yuanshine")

func checkForExist(filePath: String) -> Bool {
    return FileManager.default.fileExists(atPath: filePath)
}

extension String {
    func writeString(filePath: String) -> Bool {
        do {
            if !checkForExist(filePath: filePath) {
                FileManager.default.createFile(atPath: filePath, contents: nil)
            }
            try self.write(toFile: filePath, atomically: true, encoding: .utf8)
            return true
        } catch {
            return false
        }
    }
    
    func readString() -> String {
        do {
            return try String(contentsOfFile: self, encoding: .utf8)
        } catch {
            return "ERROR: \(error.localizedDescription)"
        }
    }
}

extension URL {
    func getPathWithoutEscape() -> String {
        return self.path().replacingOccurrences(of: "%20", with: " ")
    }
}

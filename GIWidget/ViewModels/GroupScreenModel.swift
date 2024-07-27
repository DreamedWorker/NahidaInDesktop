//
//  GroupScreenModel.swift
//  GIWidget
//
//  Created by 鸳汐 on 2024/7/23.
//

import Foundation

class GroupScreenModel : ObservableObject {
    @Published var groups: [String] = []
    @Published var filteredCha: [String] = []
    private var loadedJSON: JSON? = nil
    @Published var showExtraButton: Bool = false
    @Published var extraMsg: String = ""
    
    func loadGroups() {
        if initialGroup() {
            groups.removeAll()
            let jsonOri = rootFileURL!.appending(component: "groups.json")
                .getPathWithoutEscape().readString().data(using: .utf8)
            do {
                loadedJSON = try JSON(data: jsonOri!)
                groups = loadedJSON!["context"].arrayValue.map{ $0.stringValue }
                showExtraButton = false
                extraMsg = ""
            } catch {
                showExtraButton = true
                extraMsg = "解析JSON文件时出现问题，需要清理存储空间！"
            }
        } else {
            showExtraButton = true
            extraMsg = "运行环境异常，无法初始化文件。"
        }
    }
    
    /**
     Delete the selected item. (The group named "Traveller" cannot be removed.)
     */
    func removeGroup(index: Int) -> EventCallback {
        let required = groups[index]
        if required != "Traveller" {
            groups.remove(at: index)
            return EventCallback(eventOK: true)
        } else {
            return EventCallback(eventOK: false, message: "Cannot remove this group.")
        }
    }
    
    func addGroupItem(name: String){
        groups.append(name)
    }
    
    func saveGroups() -> Bool {
        let newValue = """
{"context": \(groups)}
"""
        return newValue.writeString(filePath: (rootFileURL?.appending(component: "groups.json").getPathWithoutEscape())!)
    }
    
    private func initialGroup() -> Bool {
        let groupFile = rootFileURL?.appending(component: "groups.json")
        if !checkForExist(filePath: groupFile!.getPathWithoutEscape()) {
            let defaultValue = """
{"context": ["Traveller"]}
"""
            return defaultValue.writeString(filePath: groupFile!.getPathWithoutEscape())
        } else {
            return true
        }
    }
}
